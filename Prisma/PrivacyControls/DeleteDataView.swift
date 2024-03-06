//
// This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

//
//  DeleteDataView.swift
//  Prisma
//
//  Created by Evelyn Hur, Caroline Tran on 2/20/24.
//

import FirebaseFirestore
import Foundation
import Spezi
import SpeziHealthKit
import SwiftUI


struct DeleteDataView: View {
    @Environment(PrivacyModule.self) private var privacyModule
    @Environment(PrismaStandard.self) private var standard
    // category identifier is passed into DeleteDataView from ManageDataView
    var categoryIdentifier: String
    
    // NEXT STEPS: timeArrayStatic will be replaced by timestampsArray which is read in from firestore using the categoryIdentifier and getPath
    @State private var timeArrayStatic = ["2023-11-14T20:39:44.467", "2023-11-14T20:41:00.000", "2023-11-14T20:42:00.000"]
    //    var timeArray = getLastTimestamps(quantityType: "stepcount")
    
    var body: some View {
        // create a list of all the time stamps for this category
        // get rid of spacing once we insert custom time range
        VStack(spacing: -400) {
            Form {
                Section(header: Text("Allow to Read")) {
                    Toggle(self.privacyModule.identifierUIString[self.categoryIdentifier] ?? "Cannot Find Data Type", isOn: Binding<Bool>(
                        get: {
                            // Return the current value or a default value if the key does not exist
                            self.privacyModule.togglesMap[self.categoryIdentifier] ?? false
                        },
                        set: { newValue in
                            // Update the dictionary with the new value
                            self.privacyModule.togglesMap[self.categoryIdentifier] = newValue
                        }
                    ))
                }
            }
            NavigationView {
                // Toggle corresponding to the proper data to exclude all data of this type
                List {
                    Section(header: Text("Delete by time")) {
                        ForEach(timeArrayStatic, id: \.self) { timestamp in
                            Text(timestamp)
                        }
                        // on delete, remove it on the UI and set flag in firebase
                        .onDelete { indices in
                            let timestampsToDelete = indices.map { timeArrayStatic[$0] }
                            deleteInBackend(identifier: categoryIdentifier, timestamps: timestampsToDelete)
                            timeArrayStatic.remove(atOffsets: indices)
                        }
                    }
                }
                .padding(.top, -40)
                .navigationBarItems(trailing: EditButton())
            }
        }
        .navigationTitle(privacyModule.identifierUIString[categoryIdentifier] ?? "Identifier Title Not Found")
    }
    
    func deleteInBackend(identifier: String, timestamps: [String]) {
        for timestamp in timestamps {
            Task {
                await standard.addDeleteFlag(selectedTypeIdentifier: identifier, timestamp: timestamp)
            }
        }
    }
}


#Preview {
    DeleteDataView(categoryIdentifier: "Example Preview: DeleteDataView")
}
