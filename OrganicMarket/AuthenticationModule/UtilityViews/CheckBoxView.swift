import SwiftUI

struct CheckBoxView: View {
    @Binding var isOn: Bool
    var body: some View {
        Image(systemName: isOn ? "checkmark.square.fill" : "square")
            .foregroundColor(isOn ? .green : .secondary)
            .onTapGesture {
                withAnimation {
                    self.isOn.toggle()
                }
            }
    }
}

//struct CheckBoxView_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckBoxView()
//    }
//}
