//
//  SecureFieldView.swift
//  ChatGPT_App
//
//  Created by Venkatesh Nyamagoudar on 6/14/23.
//

import SwiftUI

struct SecureFieldView: View {
    let placeholder: String
    let text: Binding<String>
    
    var body: some View {
        SecureField(placeholder, text: text)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
    }
}

struct SecureFieldView_Previews: PreviewProvider {
    static var previews: some View {
        SecureFieldView(placeholder: "Venki", text: .constant("Password"))
    }
}
