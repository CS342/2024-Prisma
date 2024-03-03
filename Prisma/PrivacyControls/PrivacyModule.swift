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
import Spezi
import SwiftUI


public class PrivacyModule: Module, DefaultInitializable, EnvironmentAccessible {
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
    
    public var identifierUIString: [String:String] = [
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
    
    public struct DataCategoryItem {
        var name: String
        var iconName: String
        var enabledStatus: String
    }
    var dataCategoryItems: [DataCategoryItem] = []
    
    public required init() {
        dataCategoryItems = self.getDataCategoryItems()
    }
    
    var configuration: Configuration {
        Configuration(standard: PrismaStandard()) { }
    }

    public func getDataCategoryItems() -> [DataCategoryItem] {
        var dataCategoryItems: [DataCategoryItem] = []
        // loop through keys in dict and create a list of dataCategoryItem elements
        for key in iconsMapping.keys {
            dataCategoryItems.append(DataCategoryItem(name: key,
                                                      iconName: (iconsMapping[key] ?? "unable to get icon string"), 
                                                      enabledStatus: (togglesMap[key] ?? true) ? "Enabled" : "Disabled"))
        }
        return dataCategoryItems
    }
    
    
    //    var sampleToToggleNameMapping: [String: Bool] = [
    //        getSampleIdentifier(HKSample): true,
    //        HKQuantityType.quantityType(forIdentifier: .stepCount): "includeStepCountUpload",
    //        HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning): "includeDistanceWalkingRunning",
    //        HKQuantityType.quantityType(forIdentifier: .vo2Max): "includeVo2Max",
    //        HKQuantityType.quantityType(forIdentifier: .heartRate): "includeHeartRate",
    //        HKQuantityType.quantityType(forIdentifier: .restingHeartRate): "includeRestingHeartRate",
    //        HKQuantityType.quantityType(forIdentifier: .oxygenSaturation): "includeOxygenSaturation",
    //        HKQuantityType.quantityType(forIdentifier: .respiratoryRate): "includeRespiratoryRate",
    //        HKQuantityType.quantityType(forIdentifier: .walkingHeartRateAverage): "includeWalkingHeartRateAverage"
    //    ]
    
    
    //    public func getCurrentToggles() -> [String: Bool] {
    //        [
    //            "includeStepCountUpload": includeStepCountUpload,
    //            "includeActiveEnergyBurned": includeActiveEnergyBurned,
    //            "includeDistanceWalkingRunning": includeDistanceWalkingRunning,
    //            "includeVo2Max": includeVo2Max,
    //            "includeHeartRate": includeHeartRate,
    //            "includeRestingHeartRate": includeRestingHeartRate,
    //            "includeOxygenSaturation": includeOxygenSaturation,
    //            "includeRespiratoryRate": includeRespiratoryRate,
    //            "includeWalkingHRAverage": includeWalkingHRAverage
    //        ]
    //}
    //    public func getLastTimestamps(quantityType: String) async -> [String] {
    //        var path: String = ""
    //
    //        do {
    //            path = try await standard.getPath(module: .health(quantityType)) + "raw/"
    //        } catch {
    //            print("Error retrieving user document: \(error)")
    //        }
    //
    //        var lastTimestampsArr: [String] = []
    //
    //        do {
    //            let querySnapshot = try await Firestore.firestore().collection(path).getDocuments()
    //            for document in querySnapshot.documents {
    //                lastTimestampsArr.append(document.documentID)
    ////                print("\(document.documentID) => \(document.data())")
    //            }
    //        } catch {
    //            print("Error getting documents: \(error)")
    //        }
    //
    //        return lastTimestampsArr
    //    }
    
    
}
