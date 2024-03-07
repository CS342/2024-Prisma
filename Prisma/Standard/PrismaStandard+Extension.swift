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
        // return "unknown"
        return self
    }
}

extension Date {
    /// converts Date object to ISO Format string. Can optionally pass in a time zone to convert it to.
    /// If no timezone is passed, it converts the Date object using the local time zone.
    func toISOFormat(timezone: TimeZone? = nil) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withTime, .withColonSeparatorInTime, .withFractionalSeconds]
        if let timezone = timezone {
            formatter.timeZone = timezone
        } else {
            formatter.timeZone = TimeZone.current
        }
        return formatter.string(from: self)
    }
    
    /// one Month in the past.
    func oneMonthInThePast() -> Date? {
        Calendar.current.date(byAdding: .month, value: -1, to: self)
    }
}
