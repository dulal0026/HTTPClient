//
//  ContentView.swift
//  HTTPClient
//
//  Created by Dulal Hossain on 14/10/26.
//

import SwiftUI


struct ProductsView: View {
    
    @Environment(ProductStore.self) private var productStore
    
    var body: some View {
        List(productStore.products) { product in
            ProductRowView(product: product)
        }
        .task {
            do {
                try await productStore.getProducts()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ProductsView()
        .environment(ProductStore(httpClient: HTTPClient()))
}

