//
//  ContentView.swift
//  ChatGPT_App
//
//  Created by Venkatesh Nyamagoudar on 6/13/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authenticator: AuthenticationManager
    
    var body: some View {
        NavigationView {
            if authenticator.userSignedIn {
                VerificationCheckView()
            } else {
                WelcomeView()
            }
        }
        .onAppear {
            authenticator.userSignedIn = authenticator.isSignedIn
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
