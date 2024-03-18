//
// This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import HealthKit


struct HKSampleTypeDecodable: Decodable, Hashable {
    var sampleType: HKSampleType?
    
    
    init(_ sampleType: HKSampleType) {
        self.sampleType = sampleType
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let identifier = try container.decode(String.self)
        
        // Attempt to create the specific HKSampleType based on the identifier
        if let quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier(rawValue: identifier)) {
            sampleType = quantityType
        } else if let categoryType = HKCategoryType.categoryType(forIdentifier: HKCategoryTypeIdentifier(rawValue: identifier)) {
            sampleType = categoryType
        } else if identifier == HKWorkoutTypeIdentifier {
            sampleType = HKWorkoutType.workoutType()
        } else {
            sampleType = nil
        }
    }
}
