//
//  OpenAIManager.swift
//  IOS_ASSIGNMENT_3
//
//  Created by Sill Wmith on 25/5/2023.
//

import Foundation
import Alamofire // networking framework for clean code

class OpenAIManager { //Model
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    func sendMessage(messages: [Message]) async -> OpenAIChatResponse?{
        let openAIMessages = messages.map({OpenAIChatMessage(role: $0.role, content: $0.content)})
        
        let body = OpenAIChatBody(model: "gpt-3.5-turbo", messages: openAIMessages)
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(APIKey.openAIAPIKey)"
        ]
        return try? await AF.request(baseURL, method: .post, parameters: body, encoder: .json, headers: headers).serializingDecodable(OpenAIChatResponse.self).value
    }
}

struct OpenAIChatBody: Encodable{ //make this a separate Model file 1
    let model: String
    let messages: [OpenAIChatMessage]
}

struct OpenAIChatResponse: Decodable { //make this a separate Model file 2, from OpenAI Documentation we can get the JSON response
    let choices: [OpenAIChatChoice]
}

struct OpenAIChatMessage: Codable{
    let role: SenderRole
    let content: String
}

enum SenderRole: String, Codable{
    case system
    case user
    case assistant
}

struct OpenAIChatChoice: Decodable{
    let message: OpenAIChatMessage
}
