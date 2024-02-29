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


@Observable
public class PrivacyModule: DefaultInitializable, EnvironmentAccessible {
    var configuration: Configuration {
        Configuration(standard: PrismaStandard()) { }
    }
    
    public required init() {}
    
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
