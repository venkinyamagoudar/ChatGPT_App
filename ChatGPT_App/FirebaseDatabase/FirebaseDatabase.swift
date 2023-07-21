//
//  FirebaseDatabase.swift
//  ChatGPT_App
//
//  Created by Venkatesh Nyamagoudar on 6/7/23.
//

import Firebase
import FirebaseDatabase

protocol FirebaseDatabaseServiceProtocol {
    func addUser(user: User)
    func loadMessageHistory(for userId: String, completion: @escaping ([Message]?) -> Void)
    func appendMessageToUser(userID: String, newMessage: Message, completion: @escaping (Error?) -> Void)
    func getUserDetails(id: String, completion: @escaping (Result<(String, String), Error>) -> Void)
}

class FirebaseDatabase: ObservableObject, FirebaseDatabaseServiceProtocol {
    let databaseRef: DatabaseReference
    
    init() {
        databaseRef = Database.database().reference()
    }
    
    /// Adds user to the Firebase database.
    /// - Parameter user: The details of the new user.
    func addUser(user: User) {
        guard let userDictionary = try? JSONSerialization.jsonObject(with: JSONEncoder().encode(user)) as? [String: Any] else {
            // Handle the error if unable to convert to a dictionary
            return
        }
        // Set the user data in the Firebase Realtime Database
        databaseRef.child("users").child(user.id).setValue(userDictionary) { error, _ in
            if let error = error {
                print("Failed to save user data: \(error)")
                // Call the completion block or delegate method with the error if necessary
            } else {
                print("User data saved successfully!")
                // Call the completion block or delegate method indicating success if necessary
            }
        }
    }
    
    /// Extracts user details from the given user ID.
    /// - Parameters:
    ///   - id: The ID of the logged-in user.
    ///   - completion: Returns user details like username and email.
    func getUserDetails(id: String, completion: @escaping (Result<(String, String), Error>) -> Void) {
        let userRef = databaseRef.child("users").child(id)
        userRef.observeSingleEvent(of: .value) { snapshot in
            guard let userDict = snapshot.value as? [String: Any],
                  let fullname = userDict["fullname"] as? String,
                  let email = userDict["email"] as? String else {
                // Handle error or provide default values
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve user details"])
                completion(.failure(error))
                return
            }
            completion(.success((fullname, email)))
        }
    }
    
    /// Loads message history for the given user ID.
    /// - Parameters:
    ///   - userId: The user ID.
    ///   - completion: Returns an array of messages.
    func loadMessageHistory(for userId: String, completion: @escaping ([Message]?) -> Void) {
        let userRef = databaseRef.child("users").child(userId).child("messages")
        userRef.observe(.value) { snapshot in
            guard let messageDicts = snapshot.value as? [[String: Any]] else {
                completion(nil)
                return
            }
            var messages: [Message] = []
            for messageDict in messageDicts {
                if let id = messageDict["id"] as? String,
                   let message = messageDict["message"] as? String,
                   let creationTimestamp = messageDict["creationDate"] as? TimeInterval,
                   let senderRawValue = messageDict["sender"] as? String,
                   let sender = SenderType(rawValue: senderRawValue) {
                    let creationDate = Date(timeIntervalSince1970: creationTimestamp)
                    let messageObject = Message(id: id, message: message, creationDate: creationDate, sender: sender)
                    messages.append(messageObject)
                }
            }
            // Handle the fetched messages
            completion(messages)
        }
    }
    
    /// Appends a new message to the user's messages.
    /// - Parameters:
    ///   - userID: The user ID.
    ///   - newMessage: The new message to append.
    ///   - completion: Returns an error if any.
    func appendMessageToUser(userID: String, newMessage: Message, completion: @escaping (Error?) -> Void) {
        let userRef = databaseRef.child("users").child(userID)
        userRef.child("messages").observeSingleEvent(of: .value) { snapshot, error in
            if let error = error {
                // Handle the error
                completion(error as? Error)
                return
            }
            var updatedMessages: [[String: Any]] = []
            if let messages = snapshot.value as? [[String: Any]] {
                updatedMessages = messages
            }
            let messageDictionary: [String: Any] = [
                "id": newMessage.id,
                "message": newMessage.message,
                "creationDate": newMessage.creationDate.timeIntervalSince1970,
                "sender": newMessage.sender.rawValue
            ]
            updatedMessages.append(messageDictionary)
            userRef.child("messages").setValue(updatedMessages) { error, _ in
                if let error = error {
                    // Handle the error
                    completion(error)
                } else {
                    // Update successful, handle the success scenario
                    completion(nil)
                }
            }
        }
    }
}
