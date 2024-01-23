//
// This source file is part of the Behavior based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SpeziContact
import SwiftUI


/// Displays the contacts for the Behavior.
struct Contacts: View {
    let contacts = [
        Contact(
            name: PersonNameComponents(
                givenName: "Matthew",
                familyName: "Jörke"
            ),
            title: "Study Coordinator & Developer",
            contactOptions: [
                .email(addresses: ["joerke@stanford.edu"]),
            ]
        ),
        Contact(
            name: PersonNameComponents(
                namePrefix: "Prof.",
                givenName: "James",
                familyName: "Landay"
            ),
            title: "Principal Investigator",
            contactOptions: [
                .email(addresses: ["landay@stanford.edu"])
            ]
        ),
        Contact(
            name: PersonNameComponents(
                namePrefix: "Prof.",
                givenName: "Emma",
                familyName: "Brunskill"
            ),
            title: "Principal Investigator",
            contactOptions: [
                .email(addresses: ["ebrun@stanford.edu"])
            ]
        )
    ]
    
    @Binding var presentingAccount: Bool
    
    
    var body: some View {
        NavigationStack {
            ContactsList(contacts: contacts)
                .navigationTitle(String(localized: "CONTACTS_NAVIGATION_TITLE"))
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
}


#if DEBUG
#Preview {
    Contacts(presentingAccount: .constant(false))
}
#endif
