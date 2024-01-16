//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziAccount
import SwiftUI


struct AccountSetupHeader: View {
    @Environment(Account.self) private var account
    @Environment(\._accountSetupState) private var setupState
    
    
    var body: some View {
        VStack {
            HStack {
                // Plan to replace image with logo of Behavioral App
                // Image(systemName: "star.circle.fill")
                Text("ACCOUNT_TITLE")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom)
                    .padding(.top, 30)
            }
            
            Text("ACCOUNT_SUBTITLE")
                .padding(.bottom, 8)
            Divider()
            if account.signedIn, case .generic = setupState {
                Text("ACCOUNT_SIGNED_IN_DESCRIPTION")
                    .padding()
            } else {
                VStack {
                    Text("ACCOUNT_SETUP_DESCRIPTION")
                    Text("ACCOUNT_REQUIRED_ITEMS")
                }
                .padding()
            }
        }
            .multilineTextAlignment(.center)
    }
}


#if DEBUG
#Preview {
    AccountSetupHeader()
        .environment(Account())
}
#endif
