//
// This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

//
//  ManageDataView.swift
//  Prisma
//
//  Created by Evelyn Hur on 2/28/24.
//

import SwiftUI

struct ManageDataView: View {
    @EnvironmentObject var privacyModule: PrivacyModule

    var body: some View {
        NavigationView {
            List {
                ForEach(privacyModule.sortedSampleIdentifiers, id: \.self) { sampleIdentifier in
                    NavigationLink(
                        destination: DeleteDataView(
                            categoryIdentifier: privacyModule.identifierInfo[sampleIdentifier]?.identifier ?? "missing identifier string"
                        )
                    ) {
                        HStack(alignment: .center, spacing: 10) {
                            Image(systemName: privacyModule.identifierInfo[sampleIdentifier]?.iconName ?? "missing icon name")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 35, height: 35)
                                .accessibility(label: Text(privacyModule.identifierInfo[sampleIdentifier]?.iconName ?? "missing icon name"))
                            VStack(alignment: .leading, spacing: 4) {
                                Text(privacyModule.identifierInfo[sampleIdentifier]?.uiString ?? "missing ui identifier string")
                                    .font(.headline)
                                // assume a default value of false if there is a nil value in enabledBool
                                Text((privacyModule.identifierInfo[sampleIdentifier]?.enabledBool ?? false) ? "Enabled" : "Disabled")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Manage Data")
        }
        .onReceive(privacyModule.identifierInfoPublisher) { _ in
            self.privacyModule.objectWillChange.send()
        }
    }
}

#Preview {
    ManageDataView()
}
