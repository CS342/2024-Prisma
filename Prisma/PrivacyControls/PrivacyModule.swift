//
// This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//


//  PrivacyControls.swift
//  Prisma
//
//  Created by Dhruv Naik on 2/1/24.
// Edited by Evelyn Hur and Caroline on 2/28/24.

//  SPDX-FileCopyrightText: 2023 Stanford University
//
//  SPDX-License-Identifier: MIT

import Combine
import Foundation
import HealthKit
import Spezi
import SwiftUI


public class PrivacyModule: Module, EnvironmentAccessible, ObservableObject {
    // when there are changes to the identifierInfo dictionary
    // (e.g. the user changes the enable/disabled toggle for the category type in DeleteDataView),
    // we want to signal the ManageDataView that listens for this signal and refreshes its view with new info
    public struct DataCategoryItem {
        var uiString: String
        var iconName: String
        var enabledBool: Bool
        var description: LocalizedStringKey
        var identifier: String
    }
    
    @StandardActor var standard: PrismaStandard
    
    var sortedSampleIdentifiers: [String]
    var sampleTypeList: [HKSampleType]
    var toggleMapUpdated: [String: Bool] = [:]
    
    // expose the publisher so other views can subscribe to changes in identifierInfo dict
    public var identifierInfoPublisher: AnyPublisher<Void, Never> {
        // expose the publisher without revealing its exact type
        // outside code only knows that its dealing with AnyPublisher
        identifierInfoSubject.eraseToAnyPublisher() as AnyPublisher<Void, Never>
    }
    
    
    // create a Combine publisher that sends signal to subscribers each time identifierInfo is changed
    private var identifierInfoSubject = PassthroughSubject<Void, Never>()
    
    // Dictionary mapping string identifier to all UI necessary information
    // If the enabledBool is ever changed for any items in this dict, subscribing views should refresh
    @Published public var identifierInfo: [String: DataCategoryItem] = [
        "stepcount": DataCategoryItem(
            uiString: "Step Count",
            iconName: "shoeprints.fill",
            enabledBool: true,
            description: "STEP_COUNT_DESCRIPTION",
            identifier: "stepcount"
        ),
        "distancewalkingrunning": DataCategoryItem(
            uiString: "Distance Walking Running",
            iconName: "figure.walk",
            enabledBool: true,
            description: "distance walking description",
            identifier: "distancewalkingrunning"
        ),
        "basalenergyburned": DataCategoryItem(
            uiString: "Resting Energy Burned",
            iconName: "fork.knife.circle",
            enabledBool: true,
            description: "BASAL_ENERGY_BURNED_DESCRIPTION",
            identifier: "basalenergyburned"
        ),
        "activeenergyburned": DataCategoryItem(
            uiString: "Active Energy Burned",
            iconName: "flame",
            enabledBool: true,
            description: "ACTIVE_ENERGY_BURNED_DESCRIPTION",
            identifier: "activeenergyburned"
        ),
        "flightsclimbed": DataCategoryItem(
            uiString: "Flights Climbed",
            iconName: "figure.stairs",
            enabledBool: true,
            description: "FLIGHTS_CLIMBED_DESCRIPTION",
            identifier: "flightsclimbed"
        ),
        "appleexercisetime": DataCategoryItem(
            uiString: "Exercise Time",
            iconName: "figure.run.square.stack",
            enabledBool: true,
            description: "APPLE_EXERCISE_TIME_DESCRIPTION",
            identifier: "appleexercisetime"
        ),
        "applemovetime": DataCategoryItem(
            uiString: "Move Time",
            iconName: "figure.cooldown",
            enabledBool: true,
            description: "APPLE_MOVE_TIME_DESCRIPTION",
            identifier: "applemovetime"
        ),
        "applestandtime": DataCategoryItem(
            uiString: "Stand Time",
            iconName: "figure.stand",
            enabledBool: true,
            description: "APPLE_STAND_TIME_DESCRIPTION",
            identifier: "applestandtime"
        ),
        "heartrate": DataCategoryItem(
            uiString: "Heart Rate",
            iconName: "waveform.path.ecg",
            enabledBool: true,
            description: "HEART_RATE_DESCRIPTION",
            identifier: "heartrate"
        ),
        "restingheartrate": DataCategoryItem(
            uiString: "Resting Heart Rate",
            iconName: "arrow.down.heart",
            enabledBool: true,
            description: "RESTING_HEART_RATE_DESCRIPTION",
            identifier: "restingheartrate"
        ),
        "heartratevariabilitysdnn": DataCategoryItem(
            uiString: "Heart Rate Variability",
            iconName: "chart.line.uptrend.xyaxis",
            enabledBool: true,
            description: "HEART_RATE_VARIABILITY_SDNN_DESCRIPTION",
            identifier: "heartratevariabilitysdnn"
        ),
        "walkingheartrateaverage": DataCategoryItem(
            uiString: "WalkingHeartRateAverage",
            iconName: "figure.walk.motion",
            enabledBool: true,
            description: "WALKING_HEART_RATE_DESCRIPTION",
            identifier: "walkingheartrateaverage"
        ),
        "oxygensaturation": DataCategoryItem(
            uiString: "Oxygen Saturation",
            iconName: "drop.degreesign",
            enabledBool: true,
            description: "OXYGEN_SATURATION_DESCRIPTION",
            identifier: "oxygensaturation"
        ),
        "respiratoryrate": DataCategoryItem(
            uiString: "Respiratory Rate",
            iconName: "lungs.fill",
            enabledBool: true,
            description: "RESPIRATORY_RATE_DESCRIPTION",
            identifier: "respiratoryrate"
        ),
        "bodytemperature": DataCategoryItem(
            uiString: "Body Temperature",
            iconName: "medical.thermometer",
            enabledBool: true,
            description: "BODY_TEMPERATURE_DESCRIPTION",
            identifier: "bodytemperature"
        ),
        "sleepanalysis": DataCategoryItem(
            uiString: "Sleep Analysis",
            iconName: "bed.double.fill",
            enabledBool: true,
            description: "SLEEP_ANALYSIS_DESCRIPTION",
            identifier: "sleepanalysis"
        ),
        "workout": DataCategoryItem(
            uiString: "Workout",
            iconName: "figure.strengthtraining.functional",
            enabledBool: true,
            description: "workout description",
            identifier: "workout"
        )
    ]
    
    var configuration: Configuration {
        Configuration(standard: PrismaStandard()) { }
    }
    
    public required init(sampleTypeList: [HKSampleType]) {
        self.sampleTypeList = sampleTypeList
        var sampleTypeIdentifiers: [String] = []
        for sampleType in sampleTypeList {
            if sampleType == HKWorkoutType.workoutType() {
                sampleTypeIdentifiers.append("workout")
            } else {
                sampleTypeIdentifiers.append(sampleType.identifier.healthKitDescription)
            }
        }
        sortedSampleIdentifiers = sampleTypeIdentifiers.sorted()
        print(sortedSampleIdentifiers)
    }
    
    // this function is called by DeleteDataView to signal a change each time it changes a bool value
    public func updateAndSignalOnChange(identifierString: String, newToggleVal: Bool) {
        identifierInfo[identifierString]?.enabledBool = newToggleVal
        print("Updated toggle status for \(identifierString) to: \(String(describing: identifierInfo[identifierString]?.enabledBool))")
        identifierInfoSubject.send()
        print("Change detected in identifierInfo dictionary, signal sent to all subscriber views.")
    }

    public func configure() {
        Task {
            toggleMapUpdated = await getHKSampleTypeMappings()
        }
    }
    
    public func getHKSampleTypeMappings() async -> [String: Bool] {
        var toggleMapUpdated: [String: Bool] = [:]

        for sampleType in sampleTypeList {
            let identifier = await standard.getSampleIdentifierFromHKSampleType(sampleType: sampleType)
            toggleMapUpdated[identifier ?? "Unidentified Sample Type"] = true
        }
        return toggleMapUpdated
    }
}
