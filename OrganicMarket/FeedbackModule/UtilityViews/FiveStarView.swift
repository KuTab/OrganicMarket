//
//  FiveStarView.swift
//  OrganicMarket
//
//  Created by Egor Dadugin on 22.05.2023.
//

import SwiftUI

struct FiveStarView: View {
    @Binding var rating: Int
    
    var body: some View {
        HStack {
            ForEach(1..<6) { number in
                Image(systemName: number > rating ? "star" : "star.fill")
                    .foregroundColor(number > rating ? Color.gray : Color.yellow)
                    .onTapGesture {
                        rating = number
                    }
            }
        }
    }
}

struct FiveStarView_Previews: PreviewProvider {
    @State static var rating: Int = 0
    static var previews: some View {
        FiveStarView(rating: $rating)
    }
}
