//
// This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SwiftUI
import WebKit
import Firebase

struct ChatView: View {
    @Binding var presentingAccount: Bool
    @State private var token: String? = nil

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                // Fetch JWT token asynchronously
                if let token = token {
                    if let url = URL(string: "http://localhost:3000?token=\(token)") {
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
                    Text("Failed to get JWT token")
                }
            }
            .onAppear {
                self.generateJWT { token in
                    self.token = token
                }
                self.signInWithFirebase()
            }
        }
    }

    init(presentingAccount: Binding<Bool>) {
        self._presentingAccount = presentingAccount
    }

}


extension ChatView {
    func signInWithFirebase() {
        Auth.auth().signInAnonymously { (authResult, error) in
            if let error = error {
                print("Error signing in anonymously.")
                return
            }
        }
    }
    
    func generateJWT(completion: @escaping (String?) -> Void ) {
        if let currentUser = Auth.auth().currentUser {
            currentUser.getIDTokenForcingRefresh(true) { token, error in
                if let error = error {
                    print("Error getting ID token: \(error.localizedDescription)")
                    completion(nil)
                } else if let token = token {
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
        let url = URL(string: "http://localhost:3000")! // Replace with actual website, once created
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
