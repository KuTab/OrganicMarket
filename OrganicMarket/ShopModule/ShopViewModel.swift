import Foundation
import Combine

class ShopViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var cart: [CartProduct] = []
    @Published var differenceProducts: [Product?] = []
    @Published var allertShowing: Bool = false
    var allertMessage: String = ""
    var cancellables = Set<AnyCancellable>()
    var cartObserver: PassthroughSubject<Product, Never> = .init()
    var differenceObserver: PassthroughSubject<Product, Never> = .init()
    var cartEraser: PassthroughSubject<Int, Never> = .init()
    
    init() {
        cartObserver.sink { [weak self] product in
               if let index = self?.cart.firstIndex(where: { cartProduct in
                    cartProduct.product.id == product.id
               }) {
                   self?.cart[index].addNum()
               } else {
                   self?.cart.append(.init(product: product, num: 1))
               }
            print(self?.cart)
        }.store(in: &cancellables)
        
        cartEraser.sink { [weak self] id in
            if let index = self?.cart.firstIndex(where: { cartProduct in
                cartProduct.product.id == id
            }) {
                self?.cart[index].decreaseNum()
                if self?.cart[index].num == 0 {
                    self?.cart.remove(at: index)
                }
            }
//            self?.cart.removeAll { $0.num == num }
        }.store(in: &cancellables)
        
        differenceObserver.sink { [weak self] product in
            self?.addProductToDifferernce(product: product)
        }.store(in: &cancellables)
    }
    
    func fetchProducts() {
        let token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        let publisher: AnyPublisher<ServerResponse<[Product]>, Error> = NetworkService.doRequest(
            with: "http://localhost:5012/api/products/all",
            method: .get,
            headers: ["accept" : "application/json", "Content-Type" : "application/json", "Authorization" : "bearer \(token)"]
        )
        publisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished fetching products")
                case .failure(let error):
                    print("fetching products error: \(error)")
                }
            } receiveValue: { response in
                self.products = response.data ?? []
            }.store(in: &cancellables)
    }
    
    func createOrder() {
        let token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        do {
            var order = CreateOrder()
            for product in cart {
                for _ in 1...product.num {
                    order.products.append(ProductOrder(productId: product.product.id))
                }
            }
            let body = try JSONEncoder().encode(order)
            let object = try JSONSerialization.jsonObject(with: body)
            let publisher: AnyPublisher<ServerResponse<String>, Error> = NetworkService.doRequest(
                with: "http://localhost:5012/api/order/create",
                method: .post,
                headers: ["accept" : "application/json", "Content-Type" : "application/json", "Authorization" : "bearer \(token)"],
                body: object as! [String : Any]
            )
            publisher
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("finished order creation")
                    case .failure(let error):
                        print("order creation error: \(error)")
                    }
                } receiveValue: { [weak self] response in
                    if response.success {
                        self?.cart = []
                    } else {
                        self?.allertMessage = response.message
                        self?.allertShowing = true
                    }
                }.store(in: &cancellables)
        }
        catch {}
    }
    
    func addProductToDifferernce(product: Product) {
        if differenceProducts.count < 2 {
            self.differenceProducts.append(product)
        } else {
            print("В сравнении больше двух продуктов")
        }
    }
    
    func totalSum() -> NSString {
        var sum: Double = 0
        for product in cart {
            sum += product.product.price * Double(product.num)
        }
        if modf(sum).1 > 0 {
            return NSString(string: String(sum))
        }
        else {
            return NSString(format: "%.0f", sum)
        }
    }
}
