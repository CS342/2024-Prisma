//
//  PrivacyControls.swift
//  Prisma
//
//  Created by Dhruv Naik on 2/1/24.

//  SPDX-FileCopyrightText: 2023 Stanford University
//
//  SPDX-License-Identifier: MIT

import Foundation
import Spezi
import SwiftUI
import FirebaseFirestore


//@Observable
class PrivacyModule: Module/*, DefaultInitializable*/, EnvironmentAccessible {
    @StandardActor var standard: PrismaStandard
    
//    var configuration: Configuration {
//        Configuration(standard: PrismaStandard()) { }
//    }
    func configure() {
    }
    
    
    var includeStepCountUpload = false
    var includeActiveEnergyBurned = true
    var includeDistanceWalkingRunning = true
    var includeVo2Max = true
    var includeHeartRate = true
    var includeRestingHeartRate = true
    var includeOxygenSaturation = true
    var includeRespiratoryRate = true
    var includeWalkingHRAverage = true
    
    
    public func getCurrentToggles() -> [String: Bool] {
        [
            "includeStepCountUpload": includeStepCountUpload,
            "includeActiveEnergyBurned": includeActiveEnergyBurned,
            "includeDistanceWalkingRunning": includeDistanceWalkingRunning,
            "includeVo2Max": includeVo2Max,
            "includeHeartRate": includeHeartRate,
            "includeRestingHeartRate": includeRestingHeartRate,
            "includeOxygenSaturation": includeOxygenSaturation,
            "includeRespiratoryRate": includeRespiratoryRate,
            "includeWalkingHRAverage": includeWalkingHRAverage
        ]
    }
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
