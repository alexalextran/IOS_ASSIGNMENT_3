//
//  ChatViewModel.swift
//  IOS_ASSIGNMENT_3
//
//  Created by Sill Wmith on 25/5/2023.
//
import Foundation

extension ChatView {
    class ViewModel: ObservableObject {
        @Published var messages: [Message] = [Message(id: UUID(), role: .user, content: "You a mental health specialist. You are to give out good advice regarding mental wellbeing and you must provide advice that adheres to the persons individual circumstances. Your advice must help in terms of physical and mental wellbeing. Reply in one sentence only", createAt: Date())]
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
                
                if let receivedOpenAIMessage = response?.choices.first?.message {
                    let receivedMessage = Message(id: UUID(), role: receivedOpenAIMessage.role, content: receivedOpenAIMessage.content, createAt: Date())
                    
                    DispatchQueue.main.async {
                        self.messages.append(receivedMessage)
                        self.isTyping = false
                        self.typingMessageId = nil
                    }
                } else {
                    print("No response received from OpenAI API")
                    let errorMessage = Message(id: UUID(), role: .assistant, content: "No response received. Please try again later.", createAt: Date())
                    
                    DispatchQueue.main.async {
                        self.messages.append(errorMessage)
                        self.isTyping = false
                        self.typingMessageId = nil
                    }
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

