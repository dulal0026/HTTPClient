//
//  HTTPClient.swift
//  HTTPClient
//
//  Created by Dulal Hossain on 14/10/26.
//

import Foundation


enum HTTPMethod {
    case get
    case post(Data)
    case put
    case delete
    
    var rawValue: String {
        switch self {
        case .get:
            "GET"
        case .post:
            "POST"
        case .put:
            "PUT"
        case .delete:
            "DELETE"
        }
    }
    
    var body: Data? {
        switch self{
        case .post(let data):
            data
        default:
            nil
        }
    }
}


struct Resource<T: Decodable> {
    let url: URL
    var method: HTTPMethod = .get
    let responseType: T.Type
}

struct ErrorResponse: Decodable {
    let message: String
}

enum NetworkError: Error {
    case badRequest(ErrorResponse)
    case invalidResponse
    case decodingFailed(Error)
}

extension NetworkError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .badRequest(let errorResponse):
            errorResponse.message
        case .invalidResponse:
            "The server returned an invalid response."
        case .decodingFailed:
            "Unable to process the server response."
        }
    }
}

struct HTTPClient {
    
    private let session: URLSession
    private let defaultHeaders: [String: String]
    
    init(
        session: URLSession = .shared,
        defaultHeaders: [String : String] = ["Content-Type" : "application/json"]
    ) {
        self.session = session
        self.defaultHeaders = defaultHeaders
    }
    
    
    func fetch<T>(_ resource: Resource<T>) async throws -> T {
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.method.rawValue
        request.allHTTPHeaderFields = defaultHeaders
        request.httpBody = resource.method.body
        
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            do {
               return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingFailed(error)
            }
        case 400...499:
            let errorRespnse = try JSONDecoder().decode(ErrorResponse.self, from: data)
            throw NetworkError.badRequest(errorRespnse)
        default:
            throw NetworkError.invalidResponse
            
        }
    }
}
