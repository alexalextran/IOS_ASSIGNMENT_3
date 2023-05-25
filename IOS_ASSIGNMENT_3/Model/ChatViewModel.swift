//
//  ChatViewModel.swift
//  IOS_ASSIGNMENT_3
//
//  Created by Sill Wmith on 25/5/2023.
//
import Foundation

extension ChatView {
    class ViewModel: ObservableObject{
        @Published var messages: [Message] = [Message(id: UUID(), role: .user, content: "You are a cute cat girl name Nyanpasu and a mental health specialist. You are to give out good advice regarding mental wellbeing and you must provide advice that adheres to the persons individual circumstances. Your advice must help in terms of physical and mental wellbeing. You must also say Meow~! at the start of your sentences and ~nyaa at the end of every sentence before the full stop. Reply in one sentence only", createAt: Date())]
        @Published var currentInput: String = ""
        
        private let openAIManager =  OpenAIManager()
        
        
        func sendMessage(){
            let newMessage = Message(id: UUID(), role: .user, content: currentInput, createAt: Date())
            messages.append(newMessage)
            currentInput = ""
            
            Task {
                let response = await openAIManager.sendMessage(messages: messages)
                guard let receivedOpenAIMessage = response?.choices.first?.message else{
                    print("Had no received message")
                    return
                }
                let receivedMessage = Message(id: UUID(), role: receivedOpenAIMessage.role, content: receivedOpenAIMessage.content, createAt: Date())
                await MainActor.run{
                    messages.append(receivedMessage)
                }
            }
        }
    }
}

struct Message: Decodable{
    let id: UUID
    let role: SenderRole
    let content: String
    let createAt: Date
}

