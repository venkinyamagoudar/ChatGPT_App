//
//  MainChatView.swift
//  ChatGPT_App
//
//  Created by Venkatesh Nyamagoudar on 5/27/23.
//

import SwiftUI

struct ChatView: View {
    
    @State private var userEnteredText: String = ""
    @State private var chatMessageList = [Message]()
    @State private var showSettings: Bool = false
    @State private var scrollToBottom = false
    @State private var isKeyboardHidden = true
    @State private var email : String = ""
    @State private var username: String = ""
    
    @EnvironmentObject var authenticator: AuthenticationManager
    
    let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollViewReader { scrollViewProxy in
                VStack {
                    ScrollView(.vertical, showsIndicators: true) {
                        ForEach(chatMessageList) { message in
                            HStack{
                                if message.sender == .user {
                                    Spacer()
                                    UserMessageCellView(message: message, username: $username)
                                } else {
                                    GPTMessageCellView(message: message)
                                        .padding(.horizontal)
                                    Spacer()
                                }
                            }
                            .padding(.bottom, -10)
                        }
                        .onChange(of: chatMessageList) { _ in
                            scrollToBottom = true
                        }
                    }
                    .onChange(of: scrollToBottom) { newValue in
                        if newValue {
                            scrollViewProxy.scrollTo(chatMessageList.last!.id, anchor: .bottom)
                            scrollToBottom = false
                        }
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        TextEditor(text: $userEnteredText)
                            .frame(minHeight: 44, alignment: .leading)
                            .frame(maxHeight: 100)
                            .cornerRadius(10, antialiased: true)
                            .foregroundColor(.black)
                            .font(.body)
                            .padding(.horizontal)
                            .background(
                                RoundedRectangle(cornerRadius: 28)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Button{
                            if userEnteredText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                // Handle case when only whitespace characters are entered
                            } else {
                                getAnswerFor()
                            }
                            userEnteredText = ""
                        } label: {
                            Image(systemName: "paperplane.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                        }
                        .frame(width: 40, height: 40)
                        .contentShape(Circle())
                        .padding(.trailing)
                    }
                }
            }
        }
        .navigationTitle("ChatView")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showSettings = true
                }) {
                    Image(systemName: "gear")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .imageScale(.large)
                        .padding()
                }
                .sheet(isPresented: $showSettings) {
                    SettingsView(username: $username, email: $email)
                }
            }
        }
        .onAppear {
            authenticator.firebaseDatabase.loadMessageHistory(for: authenticator.auth.currentUser!.uid) { result in
                switch result {
                case .none:
                    self.chatMessageList = []
                case .some(let messages):
                    self.chatMessageList = messages
                }
            }
            authenticator.firebaseDatabase.getUserDetails(id: authenticator.auth.currentUser!.uid) { result in
                switch result {
                case .success((let username_r, let email_r)):
                    self.email = email_r
                    self.username = username_r
                case .failure(let failure):
                    print(failure)
                }
            }
        }
        .gesture(
            TapGesture()
                .onEnded { _ in
                    // Hide the keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
        )
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            // Keyboard is shown
            isKeyboardHidden = false
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            // Keyboard is hidden
            isKeyboardHidden = true
        }
    }
}

extension ChatView {
    func getAnswerFor() {
        guard !userEnteredText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        let myMessage = Message(id: UUID().uuidString,
                                message: userEnteredText,
                                creationDate: Date.now,
                                sender: SenderType.user)
        chatMessageList.append(myMessage)
        authenticator.firebaseDatabase.appendMessageToUser(userID: authenticator.auth.currentUser!.uid, newMessage: myMessage) { error in
            switch error {
            case .none:
                print("Saved Message")
            case .some(let wrapped):
                print("Save Error: \(wrapped.localizedDescription) ")
            }
        }
        networkService.requestCompletion(model: OpenAIModel.davinci.rawValue,
                                         prompt: userEnteredText,
                                         temperature: 0.1)
        {
            (result: Result<OpenAICompletionResult, Error>) in
            switch result {
            case .success(let data):
                guard let firstChoice = data.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn: ".,{}\""))) else { return }
                let gptMesssage = Message(id: data.id,
                                          message: firstChoice,
                                          creationDate: data.created.convertToDate(),
                                          sender: .GPT)
                chatMessageList.append(gptMesssage)
                authenticator.firebaseDatabase.appendMessageToUser(userID: authenticator.auth.currentUser!.uid, newMessage: gptMesssage) { error in
                    switch error {
                    case .none:
                        print("Saved Message")
                    case .some(let wrapped):
                        print("Save Error: \(wrapped.localizedDescription) ")
                    }
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
