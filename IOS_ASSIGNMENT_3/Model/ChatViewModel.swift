//
//  ChatViewModel.swift
//  IOS_ASSIGNMENT_3
//
//  Created by Sill Wmith on 25/5/2023.
//
import Foundation

extension ChatView {
    class ViewModel: ObservableObject {
        @Published var messages: [Message] = [Message(id: UUID(), role: .user, content: "Hello", createAt: Date())]
        @Published var currentInput: String = ""
        @Published var isTyping: Bool = false
        @Published var typingMessageId: UUID?
        
        private let openAIManager = OpenAIManager()
        
        func sendMessage() {
            let newMessage = Message(id: UUID(), role: .user, content: currentInput, createAt: Date())
            messages.append(newMessage)
            currentInput = ""
            
            typingMessageId = newMessage.id
            isTyping = true
            
            Task {
                let response = await openAIManager.sendMessage(messages: messages)
                guard let receivedOpenAIMessage = response?.choices.first?.message else {
                    print("Had no received message")
                    let errorMessage = Message(id: UUID(), role: .system, content: "Connection error. Please try again later.", createAt: Date())
                    
                    DispatchQueue.main.async {
                        self.messages.append(errorMessage)
                        self.isTyping = false
                        self.typingMessageId = nil
                    }
                    
                    return
                }
                
                let receivedMessage = Message(id: UUID(), role: receivedOpenAIMessage.role, content: receivedOpenAIMessage.content, createAt: Date())
                
                DispatchQueue.main.async {
                    self.messages.append(receivedMessage)
                    self.isTyping = false
                    self.typingMessageId = nil
                }
            }
        }
    }
}

struct Message: Decodable, Identifiable, Equatable{
    let id: UUID
    let role: SenderRole
    let content: String
    let createAt: Date
}

