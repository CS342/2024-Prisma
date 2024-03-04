//
// This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Firebase
import Foundation
import SpeziAccount
import SwiftUI
import WebKit

struct ChatView: View {
    @Binding var presentingAccount: Bool
    @State private var token: String?
    
    @Environment(Account.self) private var account

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
                    ProgressView()
                }
            }
            .onChange(of: account.signedIn) {
                guard account.signedIn else {
                    return
                }
                
                Task {
                    try await self.signInWithFirebase()
                }
            }
            .task {
                do {
                    try await self.signInWithFirebase()
                } catch {
                    print("Firebase Auth failed \(error)")
                }
                guard await ((try? self.signInWithFirebase()) != nil) else {
                    print("Firebase Auth failed")
                    return
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
        token = try await Auth.auth().currentUser?.getIDToken()
    }
}

#if DEBUG
struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(presentingAccount: .constant(false))
    }
}
#endif
