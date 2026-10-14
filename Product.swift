//
//  Product.swift
//  HTTPClient
//
//  Created by Dulal Hossain on 14/10/26.
//


import Foundation

struct Product: Codable, Identifiable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    
    var formattedPrice: String {
        return String(price)
    }
}
