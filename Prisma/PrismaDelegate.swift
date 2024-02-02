//
// This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import FirebaseCore
import FirebaseMessaging
import Spezi
import SpeziAccount
import SpeziFirebaseAccount
import SpeziFirebaseStorage
import SpeziFirestore
import SpeziHealthKit
import SpeziMockWebService
import SpeziOnboarding
import SpeziScheduler
import SwiftUI

class PrismaDelegate: SpeziAppDelegate {
    override var configuration: Configuration {
        Configuration(standard: PrismaStandard()) {
            if !FeatureFlags.disableFirebase {
                AccountConfiguration(configuration: [
                    .requires(\.userId),
                    .requires(\.name)
                ])
                
                if FeatureFlags.useFirebaseEmulator {
                    FirebaseAccountConfiguration(
                        authenticationMethods: [.emailAndPassword, .signInWithApple],
                        emulatorSettings: (host: "localhost", port: 9099)
                    )
                } else {
                    FirebaseAccountConfiguration(authenticationMethods: [.emailAndPassword, .signInWithApple])
                }
                firestore
                if FeatureFlags.useFirebaseEmulator {
                    FirebaseStorageConfiguration(emulatorSettings: (host: "localhost", port: 9199))
                } else {
                    FirebaseStorageConfiguration()
                }
            } else {
                MockWebService()
            }
            
            if HKHealthStore.isHealthDataAvailable() {
                healthKit
            }
            PrismaScheduler()
            OnboardingDataSource()
        }
    }
    
    
    private var firestore: Firestore {
        let settings = FirestoreSettings()
        if FeatureFlags.useFirebaseEmulator {
            settings.host = "localhost:8080"
            settings.cacheSettings = MemoryCacheSettings()
            settings.isSSLEnabled = false
        }
        
        return Firestore(
            settings: settings
        )
    }
    
    
    private var healthKit: HealthKit {
        HealthKit {
            CollectSamples(
                [
                    HKQuantityType(.activeEnergyBurned),
                    HKQuantityType(.stepCount),
                    HKQuantityType(.distanceWalkingRunning),
                    HKQuantityType(.vo2Max),
                    HKQuantityType(.heartRate),
                    HKQuantityType(.restingHeartRate),
                    HKQuantityType(.oxygenSaturation),
                    HKQuantityType(.respiratoryRate),
                    HKQuantityType(.walkingHeartRateAverage)
                ],
                /// predicate to request data from one month in the past to present.
                predicate: HKQuery.predicateForSamples(
                    withStart: Calendar.current.date(byAdding: .month, value: -1, to: .now),
                    end: nil,
                    options: .strictEndDate
                ),
                deliverySetting: .anchorQuery(.afterAuthorizationAndApplicationWillLaunch)
            )
        }
    }
}
