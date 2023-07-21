//
//  TextFieldView.swift
//  ChatGPT_App
//
//  Created by Venkatesh Nyamagoudar on 6/13/23.
//

import SwiftUI

struct TextFieldView: View {
    let placeholder: String
    let text: Binding<String>
    
    var body: some View {
        TextField(placeholder, text: text)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
        
    }
}

struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldView(placeholder: "Username", text: .constant("Venki"))
    }
}
