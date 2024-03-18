//
// This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Combine
import Foundation
import HealthKit
import Spezi
import SpeziLocalStorage
import SwiftUI


@Observable
class PrivacyModule: Module, EnvironmentAccessible {
    #warning("We should consider storing the privacy module preferences in Firebase.")
    @ObservationIgnored @Dependency private var localStorage: LocalStorage
    
    let sampleTypes: [HKSampleType]
    var collectDataTypes: [HKSampleType: Bool] = [:] {
        didSet {
            try? localStorage.store(collectDataTypes, storageKey: StorageKeys.privacyControlsSampleTypes)
        }
    }
    
    
    required init(sampleTypes: [HKSampleType]) {
        self.sampleTypes = sampleTypes
    }
    

    func configure() {
        let storedCollectDataTypes = (
            try? localStorage.read([HKSampleTypeDecodable: Bool].self, storageKey: StorageKeys.privacyControlsSampleTypes)
        ) ?? [:]
        
        for sampleType in sampleTypes {
            collectDataTypes[sampleType] = storedCollectDataTypes[HKSampleTypeDecodable(sampleType)] ?? true
        }
    }
    
    func binding(for sampleType: HKSampleType) -> Binding<Bool> {
        Binding(
            get: {
                self.collectDataTypes[sampleType, default: false]
            },
            set: { newValue in
                self.collectDataTypes[sampleType] = newValue
            }
        )
    }
}
