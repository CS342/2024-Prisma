//
// This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct ManageDataView: View {
    @Environment(PrivacyModule.self) var privacyModule
    @Environment(PrismaStandard.self) var prismaStandard
    
    @Binding var presentingAccount: Bool
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(privacyModule.sampleTypes, id: \.identifier) { sampleIdentifier in
                    NavigationLink(
                        destination: PrivacyDetailView(sampleIdentifier, standard: prismaStandard)
                    ) {
                        HStack {
                            Label(
                                title: {
                                    Text(sampleIdentifier.title)
                                },
                                icon: {
                                    Image(systemName: sampleIdentifier.systemImage)
                                        .accessibilityHidden(true)
                                }
                            )
                            Spacer()
                            Text("\(privacyModule.collectDataTypes[sampleIdentifier, default: false] ? Text("Enabled") : Text("Disabled"))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
                .navigationTitle("Manage Data")
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


#Preview {
    ManageDataView(presentingAccount: .constant(false))
        .previewWith {
            PrivacyModule(sampleTypes: PrismaDelegate.healthKitSampleTypes)
        }
}
