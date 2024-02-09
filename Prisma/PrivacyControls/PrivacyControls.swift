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
    var includeStepCountUpload = false
    var includeActiveEnergyBurned = true
    var includeDistanceWalkingRunning = true
    var includeVo2Max = true
    var includeHeartRate = true
    var includeRestingHeartRate = true
    var includeOxygenSaturation = true
    var includeRespiratoryRate = true
    var includeWalkingHRAverage = true
    
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
}
