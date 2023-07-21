//
//  GPTMessageCellView.swift
//  ChatGPT_App
//
//  Created by Venkatesh Nyamagoudar on 5/27/23.
//

import SwiftUI

struct GPTMessageCellView: View {
    var message: Message
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                Image(uiImage:
                        (getImage(from: "Enetr url")))
                .resizable()
                .scaledToFit()
                .background(Color.green)
                .clipShape(Circle())
                .foregroundColor(.blue)
                .frame(width: 25, height: 25)
                .padding([.top,.leading],10)
                Text("GPT")
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
                    .padding([.top],10)
            }
            Text(message.message)
                .foregroundColor(.primary)
                .padding(.leading, 25)
                .padding([.bottom,.trailing],10)
        }
        .background(.gray.opacity(0.3))
        .cornerRadius(15)
        .padding(.leading,5)
    }
    func getImage(from urlString: String) -> UIImage {
        return UIImage(systemName: "person")!
    }
}

//struct GPTMessageCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        let message = Message(id: UUID().uuidString, message: "Chat gpt project kbndjhbwhjnsjdc jehjcsjnjnjd hehcjknjnknjknkjnjn", creationDate: Date.now, sender: .GPT)
//        GPTMessageCellView(message: message)
//    }
//}
