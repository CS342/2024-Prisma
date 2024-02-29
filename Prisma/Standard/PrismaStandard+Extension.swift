//
// This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation


extension String {
    /// converts a HKSample Type string representation to a lower cased id.
    /// e.g. "HKQuantityTypeIdentifierStepCount" => "stepcount".
    var healthKitDescription: String {
        if self == "workout" {
            return "workout"
        }
        
        let prefixes = ["HKQuantityTypeIdentifier", "HKCategoryTypeIdentifier", "HKCorrelationTypeIdentifier", "HKWorkoutTypeIdentifier"]
        for prefix in prefixes where self.hasPrefix(prefix) {
            return self.dropFirst(prefix.count).lowercased()
        }
        return "unknown"
    }
}

extension Date {
    /// converts Date obejct to local time.
    func localISOFormat() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withTime, .withColonSeparatorInTime, .withFractionalSeconds]
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
    
    /// one Month in the past.
    func oneMonthInThePast() -> Date? {
        Calendar.current.date(byAdding: .month, value: -1, to: self)
    }
}
