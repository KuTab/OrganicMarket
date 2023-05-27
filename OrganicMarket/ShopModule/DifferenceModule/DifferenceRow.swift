import SwiftUI

struct DifferenceRow<Type: Any>: View {
    var header: String
    var leftItem: Type?
    var rightItem: Type?
    var forRating: Bool = false
    var columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        GeometryReader { reader in
            VStack(alignment: .center) {
                Text(header)
                    .padding()
                LazyVGrid(columns: columns) {
                    if let leftItem = leftItem {
                        if forRating {
                            HStack {
                                OneStarView(rating: leftItem as! Double)
                                Text(String(leftItem as! Double))
                            }
                            .frame(minWidth: reader.size.width/2, maxWidth: reader.size.width/2)
                            .padding()
                        } else {
                            Text(String(describing: leftItem))
                                .frame(minWidth: reader.size.width/2, maxWidth: reader.size.width/2)
                                .padding()
                        }
                    }
                    
                    
                    if let rightItem = rightItem {
                        if forRating {
                            HStack {
                                OneStarView(rating: rightItem as! Double)
                                Text(String(rightItem as! Double))
                            }
                            .frame(minWidth: reader.size.width/2, maxWidth: reader.size.width/2)
                            .padding()
                        } else {
                            Text(String(describing: rightItem))
                                .frame(minWidth: reader.size.width/2, maxWidth: reader.size.width/2)
                                .padding()
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
            .background {
                Color.white
            }
            .cornerRadius(30)
            .shadow(color: .black.opacity(0.3), radius: 3)
        }
    }
}

struct DifferenceRow_Previews: PreviewProvider {
    static var previews: some View {
        //DifferenceRow<String>(header: "Цена", leftItem: "350 руб.", rightItem: "400 руб.")
        DifferenceRow<Double>(header: "Рейтинг", leftItem: 5.0, rightItem: 4.0, forRating: true)
    }
}
