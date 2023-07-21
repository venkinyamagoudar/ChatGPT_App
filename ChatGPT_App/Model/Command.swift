//
//  Command.swift
//  ChatGPT_App
//
//  Created by Venkatesh Nyamagoudar on 5/28/23.
//

import Foundation

//MARK: Command
struct Command: Codable {
    let prompt: String
    let model: String
    let maxTokens: Int
    let temperature: Double
    
    enum CodingKeys: String, CodingKey {
        case prompt
        case model
        case maxTokens = "max_tokens"
        case temperature
    }
}
