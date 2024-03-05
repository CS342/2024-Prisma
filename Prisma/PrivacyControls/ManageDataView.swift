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
    @Environment(PrivacyModule.self) private var privacyModule
    var body: some View {
        NavigationView {
            List(privacyModule.dataCategoryItems, id: \.name) { item in
                NavigationLink(destination: DeleteDataView(categoryIdentifier: item.name)) {
                    HStack(alignment: .center, spacing: 10) {
                        Image(systemName: item.iconName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                            .accessibility(label: Text("accessibility text temp"))
                        VStack(alignment: .leading, spacing: 4) {
                            Text(privacyModule.identifierUIString[item.name] ?? "Identifier UI String Not Found")
                                .font(.headline)
                            Text(item.enabledStatus)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Manage Data")
        }
    }
}

#Preview {
    ManageDataView()
}
