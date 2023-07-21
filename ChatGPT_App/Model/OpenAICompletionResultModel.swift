//
//  OpenAICompletionResultModel.swift
//  ChatGPT_App
//
//  Created by Venkatesh Nyamagoudar on 5/28/23.
//

import Foundation

// MARK: - OpenAICompletionResult
struct OpenAICompletionResult: Decodable {
    let id, object: String
    let created: TimeInterval
    let model: String
    let choices: [Choice]
    let usage: Usage
}

// MARK: - Choice
struct Choice: Decodable {
    let text: String
    let index: Int
}

// MARK: - Usage
struct Usage: Decodable {
    let promptTokens, completionTokens, totalTokens: Int

    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}
