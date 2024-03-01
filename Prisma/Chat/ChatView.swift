//
// This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Firebase
import Foundation
import SwiftUI
import WebKit

struct ChatView: View {
    @Binding var presentingAccount: Bool
    @State private var token: String?

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                // Fetch JWT token asynchronously
                if let token = token {
                    if let url = URL(string: "http://localhost:3000?token=\(token)") {  // this needs to be sent to the frontend
                        WebView(url: url)
                            .navigationTitle("Chat")
                            .frame(
                                width: geometry.size.width,
                                height: geometry.size.height
                            )
                    } else {
                        Text("Invalid URL")
                    }
                } else {
                    // Handle case where token is nil
                    // Text("Failed to get JWT token")
                    ProgressView()
                }
            }
            .task {
                guard await ((try? self.signInWithFirebase()) != nil) else {
                    print("Firebase Auth failed")
                    return
                }
                
                self.generateJWT { token in
                    self.token = token
                }
            }
        }
    }

    init(presentingAccount: Binding<Bool>) {
        self._presentingAccount = presentingAccount
    }
}

extension ChatView {
    func signInWithFirebase() async throws {
        try await Auth.auth().signIn(withCustomToken: token ?? "")
    }
    
    func generateJWT(completion: @escaping (String?) -> Void ) {
        if let currentUser = Auth.auth().currentUser {
            // Generating JWT Token
            currentUser.getIDTokenForcingRefresh(true) { (token, error) in
                if let error = error {
                    print("Error getting ID token: \(error.localizedDescription)")
                    completion(nil)
                } else if let token = token { // Setting the JWT token and send it to chat
                    print("JWT is: \(token)")
                    sendTokenToBackend(token: token, completion: completion)
                } else {
                    print("No token received.")
                    completion(nil)
                }
            }
        } else {
            print("No current user")
            completion(nil)
        }
    }
    
    func sendTokenToBackend(token: String, completion: @escaping (String?) -> Void) {
        let url = URL(string: "http://localhost:5000")! // Replace with actual website, once created
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            // Handle response from backend
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response from backend: \(responseString)")
                completion(responseString)
            } else if let error = error {
                print("Error sending token to backend: \(error.localizedDescription)")
                completion(nil)
            } else {
                print("No response received from backend")
                completion(nil)
            }
        }
        task.resume()
    }
}

#if DEBUG
struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(presentingAccount: .constant(false))
    }
}
#endif
