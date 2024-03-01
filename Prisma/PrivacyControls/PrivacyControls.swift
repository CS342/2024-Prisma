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


@Observable
public class PrivacyModule: Module, DefaultInitializable, EnvironmentAccessible {
    var configuration: Configuration {
        Configuration(standard: PrismaStandard()) { }
    }
    
    public required init() {}
    
//    @StandardActor var standard: PrismaStandard
//    let prismaDelegate = PrismaDelegate()
    
    // create the two dictionaries that would help us create:
        // the Manage Data screen: a list of data categories
        // the DeleteDataView specific to each category (would use the bool and the identifier to call getPath())

    public var iconsMapping: [String: String] = 
    [
        "activeenergyburned" : "flame",
        "distancewalkingrunning" : "figure.walk",
        "heartrate" : "waveform.path.ecg.rectangle.fill",
        "oxygensaturation": "drop.fill",
        "respiratoryrate" : "lungs.fill",
        "restingheartrate" : "arrow.down.heart.fill",
        "stepcount" : "shoeprints.fill",
        "vo2max" : "wind",
        "walkingheartrateaverage" : "figure.step.training"
    ]
    
    public var togglesMap: [String: Bool] = [:]
    public func setTogglesMapToTrue() {
        let samples =
        [
            "activeenergyburned",
            "distancewalkingrunning",
            "heartrate",
            "oxygensaturation",
            "respiratoryrate",
            "restingheartrate",
            "stepcount",
            "vo2max",
            "walkingheartrateaverage"
        ]
        
        for sample in samples {
//            let identifier = standard.getSampleIdentifier(sample)
            togglesMap[sample] = true
        }
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
