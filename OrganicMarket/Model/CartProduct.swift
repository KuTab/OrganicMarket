import Foundation

struct CartProduct: Hashable {
    let product: Product
    var num: Int
    
    mutating func addNum() {
        self.num += 1
    }
    
    mutating func decreaseNum() {
        self.num -= 1
    }
}
