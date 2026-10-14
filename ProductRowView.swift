//
//  ProductRowView.swift
//  HTTPClient
//
//  Created by Dulal Hossain on 14/10/26.
//

import SwiftUI

struct ProductRowView: View {
    let product: Product
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            Text(product.title)
                .fontWeight(.bold)
            HStack(alignment: .center) {
                Text(product.category)
                    .fontWeight(.medium)
                Spacer()
                Text(product.formattedPrice)
                    .fontWeight(.medium)
            }
           Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray)
                .opacity(0.6)
           
        }
    }
}

#Preview {
    ProductRowView(
        product: Product(
            id: 1,
            title: "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
            price: 109.95,
            description: "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
            category: "men's clothing",
            image: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_t.png"
        )
    )
}
