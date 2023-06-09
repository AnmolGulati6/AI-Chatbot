//
//  ChatViewModel.swift
//  implementAI
//
//  Created by Anmol Gulati on 6/9/23.
//

import Foundation
extension ContentView {
    class ViewModel: ObservableObject {
        // replace your prompt for the AI with You are Elon Musk
        @Published var messages: [Message] = [Message(id: UUID(), role: .user, content: "You are Elon Musk", createAt: Date())]
        @Published var currentInput: String = ""
        
        private let openAIService = OpenAIService()
        
        func sendMessage() {
            let newMessage = Message(id: UUID(), role: .user, content: currentInput, createAt: Date())
            messages.append(newMessage)
            currentInput = ""
            
            Task {
                let response = await openAIService.sendMessage(messages: messages)
                guard let recievedOpenAIMessage = response?.choices.first?.message  else {
                    print("Had no recieved message")
                    return
                } 
                let recievedMessage = Message(id: UUID(), role: recievedOpenAIMessage.role, content: recievedOpenAIMessage.content, createAt: Date())
                await MainActor.run {
                    messages.append(recievedMessage)

                }
            }
        }
    }
}

struct Message: Decodable {
    let id: UUID
    let role: SenderRole
    let content: String
    let createAt: Date
}
