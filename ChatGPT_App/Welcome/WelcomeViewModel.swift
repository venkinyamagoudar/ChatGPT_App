//
//  WelcomeViewModel.swift
//  ChatGPT_App
//
//  Created by Venkatesh Nyamagoudar on 6/12/23.
//

import SwiftUI

class WelcomeViewModel: ObservableObject {
    @Published var typedText: String = ""
    @Published var textColor: Color = .white
    
    private let textOptions = ["Let's Go", "ChatGPT", "Let's brainstorm", "Let's Design", "Let's Learn","Let's Invent"]
    var currentIndex = 0
    private var timer: Timer?
    private let textColors: [Color] = [.green, .indigo,.mint, .orange, .purple, .yellow, .cyan, .pink]
    
    func animateText() {
        resetAnimation()
        
        let characters = Array(textOptions[currentIndex])
        var charIndex = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard charIndex < characters.count else {
                self?.stopAnimation()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.typedText = ""
                    self?.currentIndex = (self!.currentIndex + 1) % (self!.textOptions.count)
                    self?.textColor = self?.textColors[self!.currentIndex] ?? .white
                    self?.animateText()
                }
                return
            }
            
            self?.typedText += String(characters[charIndex])
            charIndex += 1
        }
    }
    
    private func stopAnimation() {
        timer?.invalidate()
        timer = nil
    }
    
    private func resetAnimation() {
        stopAnimation()
        typedText = ""
    }
}
