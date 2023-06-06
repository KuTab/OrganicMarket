import SwiftUI

struct TitleRow: View {
    var name: String
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading) {
                Text("\(name)")
                    .font(.title)
                    .bold()
            }.frame(maxWidth: .infinity, alignment: .leading)
        }.padding()
    }
}

struct TitleRow_Previews: PreviewProvider {
    static var previews: some View {
        TitleRow(name: "Sarah Smith")
            .background(Color("Peach"))
    }
}
