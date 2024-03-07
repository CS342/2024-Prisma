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
            /*
             .onChange(of: account.signedIn) {
             guard account.signedIn else {
             return
             }
             
             Task {
             try await self.signInWithFirebase()
             }
             }
             */
            .task {
                do {
                    try await self.getFirebaseIDToken()
                } catch {
                    print("Firebase Auth failed \(error)")
                }
            }
        }
    }
    
    init(presentingAccount: Binding<Bool>) {
        self._presentingAccount = presentingAccount
    }
}

extension ChatView {
    func getFirebaseIDToken() async throws {
        token = try await Auth.auth().currentUser?.getIDToken()
        
        1+1
    }
}

#if DEBUG
struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(presentingAccount: .constant(false))
    }
}
#endif
