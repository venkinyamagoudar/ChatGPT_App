//
//  Message.swift
//  ChatGPT_App
//
//  Created by Venkatesh Nyamagoudar on 5/27/23.
//

import SwiftUI

// MARK: - User
struct User: Identifiable, Codable {
    var id: String
    var fullname: String
    var email: String
    var messages: [Message]
}

// MARK: - Message
struct Message: Identifiable,Codable {
    var id = UUID().uuidString
    var message: String
    var creationDate: Date
    var sender: SenderType
}

extension User: Equatable {
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "fullname": fullname,
            "email": email,
            "messages": messages.map { $0.toDictionary() }
        ]
    }
}

extension Message: Equatable {
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "message": message,
            "creationDate": creationDate.timeIntervalSince1970,
            "sender": sender.rawValue
        ]
    }
}

//MARK: Mock Data
extension User {
    static var Mock_User = User(id: UUID().uuidString, fullname: "Test1", email: "test1@gmail.com", messages: [Message.Mock_Message])
}

extension Message {
    static var Mock_Message = Message(id: UUID().uuidString, message: "Test1", creationDate: Date.now, sender: .user)
}
