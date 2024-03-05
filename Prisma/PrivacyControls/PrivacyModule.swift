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

import Foundation
import HealthKit
import Spezi
import SwiftUI


public class PrivacyModule: Module, EnvironmentAccessible {
    public struct DataCategoryItem {
        var name: String
        var iconName: String
        var enabledStatus: String
    }
    
    public var iconsMapping: [String: String] = [
        "activeenergyburned": "flame",
        "distancewalkingrunning": "figure.walk",
        "heartrate": "waveform.path.ecg",
        "oxygensaturation": "drop.fill",
        "respiratoryrate": "lungs.fill",
        "restingheartrate": "arrow.down.heart.fill",
        "stepcount": "shoeprints.fill",
        "vo2max": "wind",
        "walkingheartrateaverage": "figure.step.training"
    ]
    
    public var togglesMap: [String: Bool] = [
        "activeenergyburned": true,
        "distancewalkingrunning": true,
        "heartrate": true,
        "oxygensaturation": true,
        "respiratoryrate": true,
        "restingheartrate": true,
        "stepcount": true,
        "vo2max": true,
        "walkingheartrateaverage": true
    ]
    
    public var identifierUIString: [String: String] = [
        "activeenergyburned": "Active Energy Burned",
        "distancewalkingrunning": "Distance Walking Running",
        "heartrate": "Heart Rate",
        "oxygensaturation": "Oxygen Saturation",
        "respiratoryrate": "Respiratory Rate",
        "restingheartrate": "Resting Heart Rate",
        "stepcount": "Step Count",
        "vo2max": "VO2 Max",
        "walkingheartrateaverage": "Walking Heart Rate Average"
    ]

    var dataCategoryItems: [DataCategoryItem] = []
    var sampleTypeList: [HKSampleType]
    
    @StandardActor var standard: PrismaStandard
    
    public required init(sampleTypeList: [HKSampleType]) {
        self.sampleTypeList = sampleTypeList
        self.dataCategoryItems = self.getDataCategoryItems()
    }
    
    var configuration: Configuration {
        Configuration(standard: PrismaStandard()) { }
    }

    public func getDataCategoryItems() -> [DataCategoryItem] {
        // make dictionary into alphabetically sorted array of key-value tuples
        let sortedDataCategoryItems = identifierUIString.sorted { $0.key < $1.key }
        for dataCategoryPair in sortedDataCategoryItems {
            dataCategoryItems.append(
                DataCategoryItem(
                    name: dataCategoryPair.0,
                    iconName: (iconsMapping[dataCategoryPair.0] ?? "unable to get icon string"),
                    enabledStatus: (togglesMap[dataCategoryPair.0] ?? true) ? "Enabled" : "Disabled"
                )
            )
        }
        return dataCategoryItems
    }
    
    public func getHKSampleTypeMappings() async {
        var toggleMapUpdated: [String: Bool] = [:]

        for sampleType in sampleTypeList {
            let identifier = await standard.getSampleIdentifierFromHKSampleType(sampleType: sampleType)
            toggleMapUpdated[identifier ?? "Unidentified Sample Type"] = true
        }
    }
    
}
