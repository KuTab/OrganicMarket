import SwiftUI

struct TitleRow: View {
    //var imageURL = URL()
    var name: String
    var body: some View {
        HStack(spacing: 20) {
            //AsyncImage(url:)
//            Image("OrganicImage")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: 50, height: 50)
//                .cornerRadius(50)
            
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
