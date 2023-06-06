import SwiftUI

struct DifferenceView: View {
    @StateObject var viewModel: ShopViewModel
    @State var leftProduct: Product?
    @State var rightProduct: Product?
    var body: some View {
        VStack(alignment: .leading) {
            Text("Сравнение товаров")
                .font(.system(size: 30))
                .frame(alignment: .leading)
                .bold()
                .padding(.horizontal, 20)
            
            if viewModel.differenceProducts.isEmpty {
                Spacer()
                VStack {
                    Text("Нет товаров для сравнения")
                        .frame(maxWidth:. infinity, alignment: .center)
                        .opacity(0.5)
                }
                Spacer()
            }
            
            
            HStack(spacing: 100) {
                if let productLeft = leftProduct {
                    VStack {
                        HStack {
                            Text("\(productLeft.title)")
                            Button {
                                viewModel.differenceProducts.remove(at: 0)
                                leftProduct = rightProduct
                                rightProduct = nil
                            } label: {
                                Image(systemName: "trash.fill")
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white)
                                    .background {
                                        Color.red
                                    }
                                    .clipShape(Circle())
                            }
                        }.padding()
                    }
                }
                
                if let productRight = rightProduct {
                    VStack {
                        HStack {
                            Text("\(productRight.title)")
                            Button {
                                viewModel.differenceProducts.remove(at: 1)
                                rightProduct = nil
                            } label: {
                                Image(systemName: "trash.fill")
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white)
                                    .background {
                                        Color.red
                                    }
                                    .clipShape(Circle())
                            }
                        }.padding()
                    }
                }
            }
            
            if !viewModel.differenceProducts.isEmpty {
                ScrollView {
                    CharacteristicsView(leftProduct: leftProduct, rightProduct: rightProduct)
                }.scrollIndicators(.hidden)
            }
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .onAppear {
            if viewModel.differenceProducts.count > 0 {
                leftProduct = viewModel.differenceProducts[0]
            }
            else {
                leftProduct = nil
                rightProduct = nil
            }
            
            if viewModel.differenceProducts.count > 1 {
                rightProduct = viewModel.differenceProducts[1]
            } else {
                rightProduct = nil
            }
        }
    }
}

struct DifferenceView_Previews: PreviewProvider {
    static var previews: some View {
        DifferenceView(viewModel: .init())
    }
}

struct CharacteristicsView: View {
    var leftProduct: Product?
    var rightProduct: Product?
    var body: some View {
        VStack {
            DifferenceRow<String>(header: "Производитель", leftItem: getFullName(name: leftProduct?.supplier.name, surname: leftProduct?.supplier.surname), rightItem: getFullName(name: rightProduct?.supplier.name, surname: rightProduct?.supplier.surname))
                .frame(maxWidth: .infinity, minHeight: 110, maxHeight: .infinity)
                .padding()
            DifferenceRow<String>(header: "Цена", leftItem: String(leftProduct?.price ?? 0) + " руб.", rightItem: String(rightProduct?.price ?? 0) + " руб.")
                .frame(maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
                .padding()
            DifferenceRow<Double>(header: "Рейтинг", leftItem: leftProduct?.rating, rightItem: rightProduct?.rating, forRating: true)
                .frame(maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
                .padding()
            DifferenceRow<String>(header: "Вес/Объем", leftItem: String(leftProduct?.weight ?? 0) + (leftProduct?.getMetric() ?? ""), rightItem: String(rightProduct?.weight ?? 0) + (rightProduct?.getMetric() ?? ""))
                .frame(maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
                .padding()
            DifferenceRow<String>(header: "Состав", leftItem: leftProduct?.composition, rightItem: rightProduct?.composition)
                .frame(maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
                .padding()
            DifferenceRow<String>(header: "Срок годности", leftItem: leftProduct?.expiration, rightItem: rightProduct?.expiration)
                .frame(maxWidth: .infinity, minHeight: 100,maxHeight: .infinity)
                .padding()
            //            DifferenceRow<String>(header: "Условия хранения", leftItem: leftProduct?.storageCondition, rightItem: rightProduct?.storageCondition)
            //                .frame(maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
            //                .padding()
        }
    }
    
    private func getFullName(name: String?, surname: String?) -> String? {
        guard let name = name, let surname = surname else {
            return nil
        }
        return name + " " + surname
    }
}
