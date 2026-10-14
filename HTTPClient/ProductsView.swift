//
//  ContentView.swift
//  HTTPClient
//
//  Created by Dulal Hossain on 14/10/26.
//

import SwiftUI


extension EnvironmentValues {
    @Entry var httpClient = HTTPClient()
}

struct ProductsView: View {
    
    @Environment(\.httpClient) private var httpClient
    @State private var products: [Product] = []
    
    var body: some View {
        List(products) { product in
            ProductRowView(product: product)
        }
        .task {
           await getProducts()
        }
    }
    
    func getProducts() async {
        do {
            let url = URL(string: "https://fakestoreapi.com/products/")!
            let produR = Resource(url: url, responseType: [Product].self)
            products = try await httpClient.fetch(produR)
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    ProductsView()
}

