//
//  NetworkService.swift
//  ChatGPT_App
//
//  Created by Venkatesh Nyamagoudar on 5/28/23.
//

import Foundation

// Protocol for the Network Service
protocol NetworkServiceProtocol {
    func requestCompletion<T: Decodable>(model: String,prompt: String, temperature: Double, completion: @escaping (Result<T, Error>) -> Void)
}

// Network Service Implementation
class NetworkService: NetworkServiceProtocol {
    let apiKey: String = {
        guard let apiKey = ProcessInfo.processInfo.environment["Apikey"] else {
            fatalError("API_KEY environment variable not set.")
        }
        return apiKey
    }()
    
    /// Sends a request for model completion to the API.
    /// - Parameters:
    ///   - model: The name of the model.
    ///   - prompt: The input prompt for completion.
    ///   - temperature: The temperature parameter for generating creative responses.
    ///   - completion: Completion handler with the result of the request.
    func requestCompletion<T: Decodable>(model: String,prompt: String, temperature: Double, completion: @escaping (Result<T, Error>) -> Void) {
        let completionEndpoint = Endpoint.completions
        let urlBody = Command(prompt: prompt, model: model, maxTokens: 256, temperature: temperature)
        let urlRequest = prepareURLRequest(endPoint:completionEndpoint , body: urlBody)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(NetworkError.decode))
            }
        }
        
        task.resume()
    }
    
    /// Prepares the URLRequest for the API endpoint.
    /// - Parameters:
    ///   - endPoint: The endpoint for the API request.
    ///   - body: The command body containing prompt and model details.
    /// - Returns: The prepared URLRequest.
    private func prepareURLRequest(endPoint: Endpoint, body: Command) -> URLRequest {
        var urlComponents = URLComponents(url: URL(string: endPoint.getBaseURL())!, resolvingAgainstBaseURL: true)
        urlComponents?.path = endPoint.url
        var request = URLRequest(url: urlComponents!.url!)
        request.httpMethod = "POST"
        
        let token = apiKey
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(body) {
            request.httpBody = encoded
        }
        return request
    }
}


