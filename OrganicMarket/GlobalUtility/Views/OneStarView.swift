//
//  OneStarView.swift
//  OrganicMarket
//
//  Created by Egor Dadugin on 24.05.2023.
//

import SwiftUI

struct OneStarView: View {
    var rating: Double
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(Color.gray)
                .frame(width: 25, height: 25)
            Rectangle()
                .fill(Color.yellow)
                .frame(width: 25 * maskRating(), height: 25)
        }.mask(Image(systemName: "star.fill")
            .resizable())
            .aspectRatio(1, contentMode: .fit)
    }
    
    private func maskRating() -> Double {
        switch rating {
        case 0..<0.5:
            return 0.0
        case 0.5..<1:
            return 0.1
        case 1..<1.5:
            return 0.2
        case 1.5..<2:
            return 0.3
        case 2..<2.5:
            return 0.4
        case 2.5..<3:
            return 0.5
        case 3..<3.5:
            return 0.6
        case 3.5..<4:
            return 0.7
        case 4..<4.5:
            return 0.8
        case 4.5..<5:
            return 0.9
        case 5:
            return 1.0
        default:
            return 0.0
        }
    }
}

struct OneStarView_Previews: PreviewProvider {
    static var previews: some View {
        OneStarView(rating: 5.0)
    }
}
