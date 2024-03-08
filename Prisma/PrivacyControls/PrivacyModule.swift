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
        var description: String
        var identifier: String
    }
    
    @StandardActor var standard: PrismaStandard
    
    // INITIALIZERS: ----------------------------------------------------
    
    
    // PROPERTIES: ----------------------------------------------------
    
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
            description: "stepcount description",
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
            uiString: "Basal Energy Burned",
            iconName: "fork.knife.circle",
            enabledBool: true,
            description: "basal energy burned description",
            identifier: "basalenergyburned"
        ),
        "activeenergyburned": DataCategoryItem(
            uiString: "Active Energy Burned",
            iconName: "flame",
            enabledBool: true,
            description: "active energy burned description",
            identifier: "activeenergyburned"
        ),
        "flightsclimbed": DataCategoryItem(
            uiString: "Flights Climbed",
            iconName: "figure.stairs",
            enabledBool: true,
            description: "flights climbed description",
            identifier: "flightsclimbed"
        ),
        "appleexercisetime": DataCategoryItem(
            uiString: "Apple Exercise Time",
            iconName: "figure.run.square.stack",
            enabledBool: true,
            description: "apple exercise time",
            identifier: "appleexercisetime"
        ),
        "applemovetime": DataCategoryItem(
            uiString: "Apple Move Time",
            iconName: "figure.cooldown",
            enabledBool: true,
            description: "apple movie time description",
            identifier: "applemovetime"
        ),
        "applestandtime": DataCategoryItem(
            uiString: "Apple Stand Time",
            iconName: "figure.stand",
            enabledBool: true,
            description: "apple stand time description",
            identifier: "applestandtime"
        ),
        "heartrate": DataCategoryItem(
            uiString: "Heart Rate",
            iconName: "waveform.path.ecg",
            enabledBool: true,
            description: "heart rate description",
            identifier: "heartrate"
        ),
        "restingheartrate": DataCategoryItem(
            uiString: "Resting Heart Rate",
            iconName: "arrow.down.heart",
            enabledBool: true,
            description: "resting heart rate description",
            identifier: "restingheartrate"
        ),
        "heartratevariabilitysdnn": DataCategoryItem(
            uiString: "Heart Rate Variability SDNN",
            iconName: "chart.line.uptrend.xyaxis",
            enabledBool: true,
            description: "heart rate variability SDNN description",
            identifier: "heartratevariabilitysdnn"
        ),
        "walkingheartrateaverage": DataCategoryItem(
            uiString: "WalkingHeartRateAverage",
            iconName: "figure.walk.motion",
            enabledBool: true,
            description: "walking heart rate average description",
            identifier: "walkingheartrateaverage"
        ),
        "oxygensaturation": DataCategoryItem(
            uiString: "Oxygen Saturation",
            iconName: "drop.degreesign",
            enabledBool: true,
            description: "oxygen saturation description",
            identifier: "oxygensaturation"
        ),
        "respiratoryrate": DataCategoryItem(
            uiString: "Respiratory Rate",
            iconName: "lungs.fill",
            enabledBool: true,
            description: "respiratory rate description",
            identifier: "respiratoryrate"
        ),
        "bodytemperature": DataCategoryItem(
            uiString: "Body Tempature",
            iconName: "medical.thermometer",
            enabledBool: true,
            description: "body temperature description",
            identifier: "bodytemperature"
        ),
        "sleepanalysis": DataCategoryItem(
            uiString: "Sleep Analysis",
            iconName: "bed.double.fill",
            enabledBool: true,
            description: "sleep analysis description",
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
    
    // PUBLIC METHODS: ----------------------------------------------------
    // this function is called by DeleteDataView to signal a change each time it changes a bool value
    public func sendSignalOnChange() {
        identifierInfoSubject.send()
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
