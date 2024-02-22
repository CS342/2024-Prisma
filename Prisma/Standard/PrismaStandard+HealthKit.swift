import FirebaseFirestore
import HealthKitOnFHIR
//
// This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import ModelsR4
import SpeziFirestore
import SpeziHealthKit

/*
 
 HKQuantityType(.vo2Max),
 HKQuantityType(.heartRate),
 HKQuantityType(.restingHeartRate),
 HKQuantityType(.oxygenSaturation),
 HKQuantityType(.respiratoryRate),
 HKQuantityType(.walkingHeartRateAverage)
 

 var includeVo2Max = true
 var includeHeartRate = true
 var includeRestingHeartRate = true
 var includeOxygenSaturation = true
 var includeRespiratoryRate = true
 var includeWalkingHRAverage = true
 */


extension PrismaStandard {
    /// Adds a new `HKSample` to the Firestore.
    /// - Parameter response: The `HKSample` that should be added.
    func add(sample: HKSample) async {
        guard let quantityType = sample.sampleType as? HKQuantityType else {
            return
        }
        
        var sampleToToggleNameMapping: [HKQuantityType?: String] = [
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned): "includeActiveEnergyBurned",
            HKQuantityType.quantityType(forIdentifier: .stepCount): "includeStepCountUpload",
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning): "includeDistanceWalkingRunning",
            HKQuantityType.quantityType(forIdentifier: .vo2Max): "includeVo2Max",
            HKQuantityType.quantityType(forIdentifier: .heartRate): "includeHeartRate",
            HKQuantityType.quantityType(forIdentifier: .restingHeartRate): "includeRestingHeartRate",
            HKQuantityType.quantityType(forIdentifier: .oxygenSaturation): "includeOxygenSaturation",
            HKQuantityType.quantityType(forIdentifier: .respiratoryRate): "includeRespiratoryRate",
            HKQuantityType.quantityType(forIdentifier: .walkingHeartRateAverage): "includeWalkingHeartRateAverage"
        ]
        var toggleNameToBoolMapping: [String: Bool] = PrivacyModule().getCurrentToggles()
        
        if let variableName = sampleToToggleNameMapping[quantityType] {
            let response: Bool = toggleNameToBoolMapping[variableName] ?? false
            
            if !response {
                return
            }
        } else {
            return
        }
        
        let path: String
        
        // retrieve id of HKSample (e.g. HKQuantityTypeIdentifierStepCount)
        let identifier = quantityType.identifier
        
        // convert the startDate of the HKSample to local time
        let effectiveTimestamp = sample.startDate.localISOFormat()
        
        // path = HEALTH_KIT_PATH/raw/YYYY-MM-DDThh:mm:ss.mss
        do {
            path = try await getPath(module: .health(identifier)) + "raw/\(effectiveTimestamp)"
        } catch {
            print("Failed to define path: \(error.localizedDescription)")
            return
        }
        
        if let mockWebService {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
            let jsonRepresentation = (try? String(data: encoder.encode(sample.resource), encoding: .utf8)) ?? ""
            try? await mockWebService.upload(path: path, body: jsonRepresentation)
            return
        }
        
        // try push to Firestore.
        do {
            let deviceName = sample.sourceRevision.source.name
            let resource = try sample.resource
            let encoder = FirebaseFirestore.Firestore.Encoder()
            var firestoreResource = try encoder.encode(resource)
            firestoreResource["device"] = deviceName
            try await Firestore.firestore().document(path).setData(firestoreResource)
        } catch {
            print("Failed to set data in Firestore: \(error.localizedDescription)")
        }
    }
    
    func remove(sample: HKDeletedObject) async { }
    
    func addDeleteFlag(quantityType: String, timestamp: String) async {
        let path: String
        
        do {
            path = try await getPath(module: .health(quantityType)) + "raw/\(timestamp)"
        } catch {
            print("Failed to define path: \(error.localizedDescription)")
            return
        }
        
        // try push to Firestore.
        do {
            try await Firestore.firestore().document(path).setData(["deleteFlag" : "true"])
        } catch {
            print("Failed to set data in Firestore: \(error.localizedDescription)")
        }
    }
}
