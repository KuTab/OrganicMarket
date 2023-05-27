//
//  FiveStarInfoView.swift
//  OrganicMarket
//
//  Created by Egor Dadugin on 22.05.2023.
//

import SwiftUI

struct FiveStarInfoView: View {
   var rating: Int
    
    var body: some View {
        HStack {
            ForEach(1..<6) { number in
                Image(systemName: number > rating ? "star" : "star.fill")
                    .foregroundColor(number > rating ? Color.gray : Color.yellow)
            }
        }
    }
}

struct FiveStarInfoView_Previews: PreviewProvider {
    static var rating = 3
    static var previews: some View {
        FiveStarInfoView(rating: rating)
    }
}
