//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SwiftUI


/// Displays the contacts for the Spezi Template Application.
struct ChatView: View {
    var body: some View {
        NavigationStack {
            Text("Coming soon!")
                .navigationTitle("Chat")
        }
    }
}


#if DEBUG
struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
#endif
