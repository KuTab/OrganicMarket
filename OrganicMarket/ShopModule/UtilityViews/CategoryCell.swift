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
        ZStack(alignment: .bottomTrailing) {
            Text(category)
        }
    }
}

struct CategoryCell_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCell(category: "Test Category")
    }
}
