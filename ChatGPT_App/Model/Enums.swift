//
//  Endpoint.swift
//  ChatGPT_App
//
//  Created by Venkatesh Nyamagoudar on 5/28/23.
//

import Foundation

/// Enum defining API endpoints.
enum Endpoint {
    
    case completions,images
    /// Returns the URL path for the endpoint.
    var url: String {
        switch self {
        case .completions:
            return "/v1/completions"
        case .images:
            return "/v1/images/generation"
        }
    }
    /// Returns the base URL for the API.
    func getBaseURL() -> String  {
        return "https://api.openai.com"
    }
}

/// Enum defining the OpenAI model.
enum OpenAIModel: String {
   case davinci = "text-davinci-003"
}

/// Enum defining network errors.//MARK: NetworkError
enum NetworkError: Error {
    case invalidURL
    case noData
    case decode
    
}

/// Enum defining the sender type.
enum SenderType: String, Codable {
    case user, GPT
}
