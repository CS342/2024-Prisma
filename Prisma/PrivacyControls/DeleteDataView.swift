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
    @State private var timeArrayStatic: [String] = []
    //    var timeArray = getLastTimestamps(quantityType: "stepcount")
    @State private var crossedOutTimestamps: [String: Bool] = [:]
    @State private var customHideStartDate = Date()
    @State private var customHideEndDate = Date()
    @State private var customRangeTimestamps: [String] = []
    
    // state variable for the category toggle
    @State private var isCategoryToggleOn = false
    
    var body: some View {
        Form {
            descriptionSection
            toggleSection
            hideByCustomRangeSection
            hideByTimeSection
        }
        .navigationTitle(privacyModule.identifierInfo[categoryIdentifier]?.uiString ?? "Identifier Title Not Found")
        .onAppear {
            Task {
                timeArrayStatic = await standard.fetchTop10RecentTimeStamps(selectedTypeIdentifier: categoryIdentifier)
            }
        }
    }
    
    var descriptionSection: some View {
        Section(header: Text("About")) {
            Text(privacyModule.identifierInfo[categoryIdentifier]?.description ?? "Missing Description.")
        }
    }
    
    var toggleSection: some View {
        Section(header: Text("Allow Data Upload")) {
            Toggle(privacyModule.identifierInfo[categoryIdentifier]?.uiString ?? "Missing UI Type String ", isOn: Binding<Bool>(
                get: {
                    // get the current enable status for the toggle
                    // default to a disabled toggle if the value is missing
                    privacyModule.identifierInfo[categoryIdentifier]?.enabledBool ?? false
                },
                set: { newValue in
                    // Update dict with new toggle status, signal to other views about dict change
                    privacyModule.updateAndSignalOnChange(identifierString: categoryIdentifier, newToggleVal: newValue)
                }
            ))
        }
    }
    
    var hideByCustomRangeSection: some View {
        Section(header: Text("Hide Data by Custom Range")) {
            VStack {
                DatePicker("Start date", selection: $customHideStartDate, displayedComponents: [.date, .hourAndMinute])
                DatePicker("End date", selection: $customHideEndDate, displayedComponents: [.date, .hourAndMinute])
                
                Divider()

                Button("Hide") {
                    let startDateString = customHideStartDate.toISOFormat()
                    let endDateString = customHideEndDate.toISOFormat()
                    Task {
                        customRangeTimestamps = await standard.fetchCustomRangeTimeStamps(
                            selectedTypeIdentifier: categoryIdentifier,
                            startDate: startDateString,
                            endDate: endDateString
                        )
                    }
                    switchHiddenInBackend(identifier: categoryIdentifier, timestamps: customRangeTimestamps, alwaysHide: true)
                }
//                .frame(maxWidth: .infinity) // Make the button take full width
            }
        }
    }
    
    var hideByTimeSection: some View {
        Section(header: Text("Hide Data by Recent Timestamps")) {
            timeStampsDisplay
        }
    }
    
    var timeStampsDisplay: some View {
        ForEach(timeArrayStatic, id: \.self) { timestamp in
            HStack {
                Image(systemName: crossedOutTimestamps[timestamp, default: false] ? "eye.slash" : "eye")
                    .accessibilityLabel(crossedOutTimestamps[timestamp, default: false] ? "Hide Timestamp" : "Show Timestamp")
                    .onTapGesture {
                        switchHiddenInBackend(identifier: categoryIdentifier, timestamps: [timestamp], alwaysHide: false)
                        crossedOutTimestamps[timestamp]?.toggle() ?? (crossedOutTimestamps[timestamp] = true)
                    }
                Text(timestamp)
            }
            .foregroundColor(crossedOutTimestamps[timestamp, default: false] ? .gray : .black)
            .opacity(crossedOutTimestamps[timestamp, default: false] ? 0.5 : 1.0)
        }
    }
    
    func switchHiddenInBackend(identifier: String, timestamps: [String], alwaysHide: Bool) {
        for timestamp in timestamps {
            Task {
                await standard.switchHideFlag(selectedTypeIdentifier: identifier, timestamp: timestamp, alwaysHide: alwaysHide)
            }
        }
    }
}

struct DeleteDataView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteDataView(categoryIdentifier: "Example Preview: DeleteDataView")
    }
}
