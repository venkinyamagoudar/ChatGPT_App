//
//  SettingsView.swift
//  ChatGPT_App
//
//  Created by Venkatesh Nyamagoudar on 6/6/23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authenticator: AuthenticationManager
    @Binding var username: String
    @Binding var email: String
    
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.blue)
                        Text("Email")
                        Spacer()
                        Text(email)
                    }
                    
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(.blue)
                        Text("Fullname")
                        Spacer()
                        Text(username)
                    }
                }
                Section {
                    Button(action: {
                        // Write logout button action
                        authenticator.userSignedIn = false
                        do {
                            try authenticator.auth.signOut()
                        }
                        catch {
                            print("Failed to log out")
                        }
                    }) {
                        HStack{
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Logout")
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(username: .constant("John Doe"), email: .constant("john@example.com"))
            .environmentObject(AuthenticationManager(firebaseDatabase: FirebaseDatabase()))
    }
}
