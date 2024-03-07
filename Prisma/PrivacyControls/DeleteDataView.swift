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
    @State private var crossedOutTimestamps: [String: Bool] = [:]
    @State private var isEditing: Bool = false
    
    var body: some View {
        // create a list of all the time stamps for this category
        // get rid of spacing once we insert custom time range
        VStack(spacing: -400) {
            toggleSection
            deleteByTimeSection
        }
        .navigationTitle(privacyModule.identifierUIString[categoryIdentifier] ?? "Identifier Title Not Found")
    }
        
        var toggleSection: some View {
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
        }
    
    var deleteByTimeSection: some View {
        NavigationView {
            List {
                Section(header: Text("Hide by time")) {
                    timeStampsDisplay
                }
            }
            .padding(.top, -40)
            .navigationBarItems(trailing: Button(isEditing ? "Done" : "Edit") {
                isEditing.toggle()
            })
        }
    }
    
    var timeStampsDisplay: some View {
        ForEach(timeArrayStatic, id: \.self) { timestamp in
            HStack {
                if isEditing {
                    Image(systemName: crossedOutTimestamps[timestamp, default: false] ? "eye.slash" : "eye")
                        .onTapGesture {
                            crossedOutTimestamps[timestamp]?.toggle() ?? (crossedOutTimestamps[timestamp] = true)
                            switchHiddenInBackend(identifier: categoryIdentifier, timestamps: [timestamp])
                        }
                }
                Text(timestamp)
            }
            .foregroundColor(crossedOutTimestamps[timestamp, default: false] ? .gray : .black)
            .opacity(crossedOutTimestamps[timestamp, default: false] ? 0.5 : 1.0)
        }
    }
    
    func switchHiddenInBackend(identifier: String, timestamps: [String]) {
        for timestamp in timestamps {
            Task {
                await standard.switchDeleteFlag(selectedTypeIdentifier: identifier, timestamp: timestamp)
            }
        }
    }
}

struct DeleteDataView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteDataView(categoryIdentifier: "Example Preview: DeleteDataView")
    }
}
