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


struct ChatView: View {
    @Binding var presentingAccount: Bool
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                if let url = URL(string: "http://localhost:3000") {
                    WebView(url: url)
                        .navigationTitle("Chat")
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height
                        )
                } else {
                    Text("Invalid URL")
                }
            }
        }
    }

    init(presentingAccount: Binding<Bool>) {
        self._presentingAccount = presentingAccount
    }
}


#if DEBUG
struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(presentingAccount: .constant(false))
    }
}
#endif
