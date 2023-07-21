//
//  ActionButton.swift
//  ChatGPT_App
//
//  Created by Venkatesh Nyamagoudar on 6/13/23.
//

import SwiftUI

struct ActionButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.16, green: 0.55, blue: 0.90), Color(red: 0.22, green: 0.29, blue: 0.60)]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(10)
                .padding(.horizontal)
        }
    }
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ActionButton(title: "LogIn", action: {})
    }
}
