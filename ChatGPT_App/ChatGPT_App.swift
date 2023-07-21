//
//  ChatGPT_App.swift
//
//
//  Created by Venkatesh Nyamagoudar on 5/27/23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct ChatGPT_App: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var authenticator = AuthenticationManager(firebaseDatabase: FirebaseDatabase())

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authenticator)
        }
    }
}
