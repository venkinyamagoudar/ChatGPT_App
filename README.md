# ChatGPT App

## Introduction
ChatGPT App is a simple SwiftUI-based iOS application that allows users to have a conversation with an AI-powered language model using the OpenAI API. The app requires Firebase for user authentication and message history storage using Firebase Realtime Database. The AI capabilities are provided by the OpenAI API. Before running the app, you need to set up Firebase and obtain an API key from OpenAI.

## Technologies/Frameworks Used

| Technology/Framework        | Purpose                                       |
|----------------------------|-----------------------------------------------|
| Swift and SwiftUI          | For the iOS app development.                 |
| Firebase                   | For user authentication and realtime database storage. |
| OpenAI API                 | For AI-powered language processing.         |

## Features Implemented

1. User Authentication: Users can sign up and log in using their email and password. Firebase handles the authentication process securely.

2. Two-Factor Authentication: New users receive a verification email to confirm their email address and complete the registration process.

3. Password Reset: Users can reset their passwords by providing their email address and receiving a password reset email.

4. AI-powered Conversations: Users can have interactive conversations with the AI-powered language model provided by the OpenAI API.

5. Message History: The app stores and displays the conversation history for each user in the Firebase Realtime Database.


## Prerequisites

Before you start, the app was developed and run using the following:

1. Xcode 14.3 or later.
2. A physical iPhone device or simulator with iOS version 16 or later.

# Screenshot Gallery: ChatGPT_App

| Main View        | SignInView        | LogIn View  |
| :-------------------------:| :-------------------------:| :-----------------------: |
| ![Main View](https://github.com/venkinyamagoudar/ChatGPT_App/blob/main/ScreenShots/MainView.PNG) | ![SignIn View](https://github.com/venkinyamagoudar/ChatGPT_App/blob/main/ScreenShots/SignInView.jpeg) | ![LogIn View](https://github.com/venkinyamagoudar/ChatGPT_App/blob/main/ScreenShots/LogInView.jpeg) |
| Main view of the application | User creates his account using Full name, email and password. | User logIn to his account using his credentials. |

| Email Verification View            | Chat View    | Settings View  |
| :-------------------------:| :-------------------------:| :------------------------------: |
| ![Email Verification View](https://github.com/venkinyamagoudar/ChatGPT_App/blob/main/ScreenShots/EmailVerificationView.PNG) | ![Chat View](https://github.com/venkinyamagoudar/ChatGPT_App/blob/main/ScreenShots/Chatview.jpeg) | ![Settings View](https://github.com/venkinyamagoudar/ChatGPT_App/blob/main/ScreenShots/SettingsView.jpeg) |
| Email verification view is shown to new users who created there account and have not verified there email. | User interacts with the AI model in this view. | User ends his session by clicking Logout button from this view. |

### Video Demo
[![Video Demo](https://github.com/venkinyamagoudar/ChatGPT_App/blob/main/ScreenShots/ChatGPT.mp4)](https://github.com/venkinyamagoudar/ChatGPT_App/blob/main/ScreenShots/ChatGPT.mp4)

# How to Run the App?

## Get OpenAI API Key

1. Go to the OpenAI website: https://openai.com/
2. Sign in or create a new account.
3. After signing in, go to the "API" section or visit https://platform.openai.com/signup
4. Follow the instructions to get your API key. Keep this key secure as it grants access to the OpenAI API.

## Set OpenAI API Key as Environment Variable

Once you obtain the OpenAI API Key, you can set it as an environment variable named "Apikey" in your project. This will allow you to securely access the API key within your app. 

Here's how to set the environment variable in Xcode:

1. Navigate to "Edit Scheme" from the top menu in Xcode.

2. Select "Run" from the left sidebar.

3. Click on the "Arguments" tab.

4. Under "Environment Variables," click the "+" button to add a new variable.

5. Set the name as "Apikey" and enter the corresponding value of your OpenAI API Key.

6. Click "Close" to save the changes.

Now, your app will be able to access the OpenAI API Key securely through the environment variable "Apikey," which you can use in your API calls to interact with the OpenAI API.

> Remember to keep your API keys and sensitive information secure and do not share them publicly.

## Set Up Firebase 

1. Go to the Firebase Console: https://console.firebase.google.com/
2. Click on "Get Started" and then "Add Project".
3. Follow the on-screen instructions to set up your project.
4. After creating the project, click on "Authentication" from the left-side menu.
5. Enable "Email/Password" as a sign-in method.
6. Go back to the project overview by clicking on the Firebase icon in the top-left corner.
7. Click on "Add app" and select iOS.
8. Follow the on-screen instructions to register your app.
9. Download the `GoogleService-Info.plist` file and add it to the project's root directory in Xcode.

## Download Necessary Frameworks

The ChatGPT app uses the following frameworks, which need to be downloaded before running the project:


The ChatGPT app uses the following frameworks, which need to be downloaded before running the project:

1. Firebase (Authentication and Realtime Database): These frameworks are used for user authentication and message history storage. You can add Firebase to the project using CocoaPods or Swift Package Manager.

   - If you are using CocoaPods, add the following line to your `Podfile` and run `pod install`:
```
pod 'Firebase/Auth'
pod 'Firebase/Database'
```

   - If you are using Swift Package Manager, go to Xcode > File > Swift Packages > Add Package Dependency, and enter the Firebase GitHub URL:
https://github.com/firebase/firebase-ios-sdk.git

## CocoaPods Integration

To integrate Firebase with the project using CocoaPods, follow these steps:

1. Install CocoaPods if you haven't already. Open Terminal and run:
```sudo gem install cocoapods```


2. Navigate to the project's root directory in Terminal.

3. Create a Podfile by running the command:
```pod init```


4. Open the Podfile using a text editor and add the following lines:
```
platform :ios, '16.0'
target 'ChatGPT' do
use_frameworks!

Add Firebase pods
pod 'Firebase/Auth'
pod 'Firebase/Database'
end
```
5. Save the Podfile and run the following command in Terminal:
pod install

6. Open the newly created `ChatGPT.xcworkspace` file in Xcode.


## Run the App

1. Open the Xcode project file (`ChatGPT.xcodeproj`) in Xcode.
2. Ensure that your iOS device or simulator is selected as the build target.
3. Build and run the app by clicking the "Play" button in the top-left corner of Xcode.

# Important Note

- This app is a basic example and does not include the complete integration with the OpenAI API. To fully integrate ChatGPT capabilities into your app, you need to implement API calls to the OpenAI API based on your requirements.
- Please keep your API keys and sensitive information secure and do not share them publicly.

Enjoy your conversations with ChatGPT_APP!
