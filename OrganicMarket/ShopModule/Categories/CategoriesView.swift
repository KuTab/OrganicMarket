import SwiftUI
import Combine

struct CategoriesView: View {
    @StateObject var viewModel: CategoriesViewViewModel = .init()
    var cartObserver: PassthroughSubject<Product, Never>
    var differenceObserver: PassthroughSubject<Product, Never>
    var columns = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Категории")
                    .font(.system(size: 30))
                    .bold()
                    .padding(.horizontal, 20)
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(viewModel.categories, id: \.self) { category in
                            NavigationLink(destination: ProductsByCategoryView(category: category, cartObserver: cartObserver, differenceObserver: differenceObserver)) {
                                CategoryCell(category: category)
                                    .frame(minWidth: 170, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
                                    .background(.gray.opacity(0.2))
                                    .cornerRadius(20)
                                    .shadow(color: .black.opacity(0.3), radius: 3)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 10)
                            }.foregroundColor(.black)
                        }
                    }.padding(.leading, 10)
                        .padding(.trailing, 10)
                }.scrollIndicators(.hidden)
                    .onAppear {
                        viewModel.fetchCategories()
                    }
            }
        }.accentColor(.white)
            .toolbar(.hidden)
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var cartObserver: PassthroughSubject<Product, Never> = .init()
    static var differenceObserver: PassthroughSubject<Product, Never> = .init()
    static var previews: some View {
        CategoriesView(cartObserver: cartObserver, differenceObserver: differenceObserver)
    }
}
