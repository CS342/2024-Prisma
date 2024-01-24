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
                familyName: "Jörke,"
            ),
            image: Image(systemName: "person.crop.circle"), // swiftlint:disable:this accessibility_label_for_image
            title: "PhD Student",
            description: String(localized: "MATTHEW_JOERKE_BIO"),
            organization: "Stanford University",
            contactOptions: [
                .email(addresses: ["joerke@stanford.edu"]),
                ContactOption(
                    image: Image(systemName: "safari.fill"), // swiftlint:disable:this accessibility_label_for_image
                    title: "Website",
                    action: {
                        if let url = URL(string: "https://matthewjoerke.com/") {
                            UIApplication.shared.open(url)
                        }
                    }
                )
            ]
        ),
        Contact(
            name: PersonNameComponents(
                givenName: "Emma",
                familyName: "Brunskill"
            ),
            image: Image(systemName: "person.crop.circle"), // swiftlint:disable:this accessibility_label_for_image
            title: "Associate Professor (Tenured)",
            description: String(localized: "EMMA_BRUNSKILL_BIO"),
            organization: "Stanford University",
            contactOptions: [
                .email(addresses: ["ebrun@cs.stanford.edu"]),
                ContactOption(
                    image: Image(systemName: "safari.fill"), // swiftlint:disable:this accessibility_label_for_image
                    title: "Website",
                    action: {
                        if let url = URL(string: "https://cs.stanford.edu/people/ebrun/") {
                            UIApplication.shared.open(url)
                        }
                    }
                )
            ]
        ),
        Contact(
            name: PersonNameComponents(
                givenName: "James",
                familyName: "Landay,"
            ),
            image: Image(systemName: "person.crop.circle"), // swiftlint:disable:this accessibility_label_for_image
            title: "Professor of Computer Science",
            description: String(localized: "JAMES_LANDAY_BIO"),
            organization: "Stanford University",
            contactOptions: [
                .email(addresses: ["landay@stanford.edu"]),
                ContactOption(
                    image: Image(systemName: "safari.fill"), // swiftlint:disable:this accessibility_label_for_image
                    title: "Website",
                    action: {
                        if let url = URL(string: "https://profiles.stanford.edu/james-landay") {
                            UIApplication.shared.open(url)
                        }
                    }
                )
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
