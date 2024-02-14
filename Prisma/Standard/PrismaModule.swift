//
// This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import HealthKit


/// A `Module` is a type of data that can be uploaded to the Firestore.
enum PrismaModule {
    /// The questionnaire type with the `String` id.
    case questionnaire(String)
    /// The health type with the `HKQuantityTypeIdentifier` as a String.
    case health(String)
    
    /// The `String` description of the module.
    var description: String {
        switch self {
        case .questionnaire:
            return "questionnaire"
        case .health:
            return "health"
        }
    }
}
