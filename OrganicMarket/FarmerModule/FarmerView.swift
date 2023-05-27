import SwiftUI

struct FarmerView: View {
    @ObservedObject var viewModel = FarmerViewModel()
    @State var showAddingView: Bool = false
    var columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Мои продукты")
                    .font(.system(size: 30))
                    .bold()
                    .padding(.horizontal, 20)
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(viewModel.products, id: \.self) { product in
                            NavigationLink(destination: ProductView(product: product, farmerInitiated: true, viewModel: .init(productId: product.id))) {
                                ProductCell(product: product, adder: viewModel.productAdd)
                                    .frame(minWidth: 170, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
                                    .background(.white)
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
                        viewModel.fetchMyProducts()
                    }
            }.overlay(alignment: .bottomTrailing) {
                Button {
                    showAddingView.toggle()
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.gray)
                }.frame(minWidth: 70, maxWidth: 70, minHeight: 70, maxHeight: 70, alignment: .center)
                    .background(.white)
                    .clipShape(Circle())
                    .shadow(radius: 2)
                    .padding()
            }.sheet(isPresented: $showAddingView) {
                AddProductView(isShowed: $showAddingView, updatePublisher: viewModel.productUpdate)
            }
        }.toolbar(.hidden)
    }
}

struct FarmerView_Previews: PreviewProvider {
    static var previews: some View {
        FarmerView()
    }
}
