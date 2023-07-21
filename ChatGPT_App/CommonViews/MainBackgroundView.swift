//
//  MainBackgroundView.swift
//  ChatGPT_App
//
//  Created by Venkatesh Nyamagoudar on 6/14/23.
//

import SwiftUI

struct MainBackgroundView: View {
    var body: some View {
        RadialGradient(stops: [
            .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3)
        ], center: .bottom, startRadius: 500, endRadius: 700)
        .ignoresSafeArea()
    }
}

struct MainBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        MainBackgroundView()
    }
}


struct RoundedRectangleBackgroundView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.red]), startPoint: .top, endPoint: .bottom))
            .shadow(radius: 10)
            .padding()
    }
}
