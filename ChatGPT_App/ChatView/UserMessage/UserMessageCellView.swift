//
//  UserMessageCellView.swift
//  ChatGPT_App
//
//  Created by Venkatesh Nyamagoudar on 5/27/23.
//

import SwiftUI

struct UserMessageCellView: View {
    var message: Message
    @Binding var username: String
    
    var body: some View {
        VStack(alignment: .trailing){
            HStack {
                Image(uiImage:
                        (getImage(from: "Enetr url")))
                .resizable()
                .scaledToFit()
                .foregroundColor(.green)
                .background(.green)
                .frame(width: 20, height: 20)
                .cornerRadius(20)
                Text(username)
                    .font(.footnote)
                    .foregroundColor(.white)
            }
            Text(message.message)
                .foregroundColor(.white)
                .padding(.trailing, 20)
        }
        .padding()
        .background(.blue)
        .cornerRadius(15)
        .padding()
    }
    
    func getImage(from urlString: String) -> UIImage {
        return UIImage(systemName: "person")!
    }
}

//struct UserMessageCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        let message = Message(id: UUID().uuidString, message: "Chat gpt project hjasghdhjasdbhbhcbnjasbnbhbdhhbsbnbnbdhbhjbhd ", creationDate: Date.now, sender: .GPT)
//        UserMessageCellView(message: message, username: "Venki")
//    }
//}
