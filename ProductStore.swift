//
//  ProductStore.swift
//  HTTPClient
//
//  Created by Dulal Hossain on 14/10/26.
//

import SwiftUI
import Observation


@Observable
class ProductStore {
    
    private(set) var products: [Product] = []
    
    let httpClient: HTTPClient
    
    init(
        httpClient: HTTPClient
    ) {
        self.httpClient = httpClient
    }
    
    func getProducts() async throws{
        let url = URL(string: "https://fakestoreapi.com/products/")!
        let produR = Resource(url: url, responseType: [Product].self)
        products = try await httpClient.fetch(produR)
    }
}
