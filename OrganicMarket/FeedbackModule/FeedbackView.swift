import SwiftUI

struct FeedbackView: View {
    @ObservedObject var viewModel: FeedbackViewModel
    @Binding var isShowed: Bool
    var objectId: Int
    
    var body: some View {
        VStack {
            FiveStarView(rating: $viewModel.rate)
                .padding()
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $viewModel.feedback)
                    .frame(minHeight: 50)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 10)
                    .padding(.leading, 6)
                    .onTapGesture {
                        if viewModel.feedback == FeedbackViewModel.feedbackPlaceholder {
                            viewModel.feedback = ""
                        }
                    }
            }
            .overlay(RoundedRectangle(cornerRadius: 20)
                .stroke(.gray, lineWidth: 1))
            
            Button(action: {
                switch viewModel.feedbackType {
                case .forProduct:
                    viewModel.sendProductFeedback(productId: objectId)
                case .forSupplier:
                    viewModel.sendSupplierFeedback(supplierId: objectId)
                }
            }, label: {
                Text("Отправить")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: 65)
                        .background(.green)
            })
            .clipShape(Capsule())
            .disabled(viewModel.feedback.isEmpty || viewModel.feedback == FeedbackViewModel.feedbackPlaceholder)
        }
        .padding()
        .onChange(of: viewModel.isShowed) { newValue in
            if !newValue {
                isShowed = false
            }
        }
    }
}

struct FeedbackView_Previews: PreviewProvider {
    @State static var isShowed: Bool = true
    @ObservedObject static var viewModel: FeedbackViewModel = .init(feedbackType: .forProduct, updateFeedback: .init())
    static var previews: some View {
        FeedbackView(viewModel: viewModel, isShowed: $isShowed, objectId: 0)
    }
}
