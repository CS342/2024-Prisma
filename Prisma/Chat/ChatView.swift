//
// This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Firebase
import SwiftUI


struct ChatView: View {
    @Binding var presentingAccount: Bool
    @State private var token: String?
    
    
    private var url: URL? {
        guard let token else {
            return nil
        }
        
        return Constants.hostname.appending(queryItems: [URLQueryItem(name: token, value: token)])
    }

    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                Group {
                    if let url {
                        WebView(url: url)
                    } else {
                        VStack(spacing: 16) {
                            ProgressView()
                            Text("Loading Chat View")
                                .foregroundStyle(.secondary)
                                .font(.caption)
                        }
                    }
                }
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
            }
                .navigationTitle("Chat")
                .task {
                    await self.getFirebaseIDToken()
                }
                .toolbar {
                    if AccountButton.shouldDisplay {
                        AccountButton(isPresented: $presentingAccount)
                    }
                }
        }
    }
    
    
    init(presentingAccount: Binding<Bool>) {
        self._presentingAccount = presentingAccount
    }
    
    
    private func getFirebaseIDToken() async {
        guard !ProcessInfo.processInfo.isPreviewSimulator else {
            try? await Task.sleep(for: .seconds(1.0))
            token = "TOKEN"
            return
        }
        
        do {
            token = try await Auth.auth().currentUser?.getIDToken()
        } catch {
            print("Firebase Auth failed \(error)")
        }
    }
}


#if DEBUG
#Preview {
    ChatView(presentingAccount: .constant(false))
}
#endif
