//
// This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import FirebaseAuth
import SpeziAccount
import SpeziOnboarding
import SwiftUI


struct AccountOnboarding: View {
    @Environment(Account.self) private var account
    
    @Environment(PrismaStandard.self) private var standard
    @Environment(OnboardingNavigationPath.self) private var onboardingNavigationPath
    
    
    var body: some View {
        AccountSetup { _ in
            Task {
                guard let user = Auth.auth().currentUser else {
                    print("No signed in user.")
                    return
                }
                let accessGroup = "637867499T.edu.stanford.cs342.2024.behavior"
                
                guard (try? Auth.auth().getStoredUser(forAccessGroup: accessGroup)) == nil else {
                    print("Access group already shared ...")
                    return
                }
                
                do {
                    try Auth.auth().useUserAccessGroup(accessGroup)
                    try await Auth.auth().updateCurrentUser(user)
                } catch let error as NSError {
                    print("Error changing user access group: %@", error)
                    // log out the user if fails
                    try? Auth.auth().signOut()
                }
                
                
                // Placing the nextStep() call inside this task will ensure that the sheet dismiss animation is
                // played till the end before we navigate to the next step.
                await standard.setAccountTimestamp()
                onboardingNavigationPath.nextStep()
            }
        } header: {
            AccountSetupHeader()
        } continue: {
            OnboardingActionsView(
                "ACCOUNT_NEXT",
                action: {
                    onboardingNavigationPath.nextStep()
                }
            )
        }
    }
}


#if DEBUG
#Preview("Account Onboarding SignIn") {
    OnboardingStack {
        AccountOnboarding()
    }
    .previewWith {
        AccountConfiguration {
            MockUserIdPasswordAccountService()
        }
    }
}

#Preview("Account Onboarding") {
    let details = AccountDetails.Builder()
        .set(\.userId, value: "lelandstanford@stanford.edu")
        .set(\.name, value: PersonNameComponents(givenName: "Leland", familyName: "Stanford"))
    
    return OnboardingStack {
        AccountOnboarding()
    }
    .previewWith {
        AccountConfiguration(building: details, active: MockUserIdPasswordAccountService())
    }
}
#endif
