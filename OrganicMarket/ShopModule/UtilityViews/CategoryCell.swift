//
//  CategoryView.swift
//  OrganicMarket
//
//  Created by Egor Dadugin on 23.05.2023.
//

import SwiftUI

struct CategoryCell: View {
    var category: String
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image("CategoryImage")
                .resizable()
                .aspectRatio(1, contentMode: .fill)
            Text(category)
                .foregroundColor(.black)
                .bold()
                .padding()
                .padding(.leading)
        }
    }
}

struct CategoryCell_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCell(category: "Test Category")
    }
}
