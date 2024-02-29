//
// This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import ModelsR4
import FirebaseFirestore
import HealthKitOnFHIR
import SpeziFirestore
import SpeziHealthKit

extension PrismaStandard {
    func getSampleIdentifier(sample: HKSample) -> String? {
        switch sample {
        case let quantitySample as HKQuantitySample:
            return quantitySample.quantityType.identifier
        case let categorySample as HKCategorySample:
            return categorySample.categoryType.identifier
        case let workout as HKWorkout:
            //  return "\(workout.workoutActivityType)"
            return "workout"
        // Add more cases for other HKSample subclasses if needed
        default:
            return nil
        }
    }
    
    /// Adds a new `HKSample` to the Firestore.
    /// - Parameter response: The `HKSample` that should be added.
    func add(sample: HKSample) async {
        let identifier: String
        if let id = getSampleIdentifier(sample: sample) {
            print("Sample identifier: \(id)")
            identifier = id
        } else {
            print("Unknown sample type")
            return
        }

//        var sampleToToggleNameMapping: [HKQuantityType?: String] = [
//            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned): "includeActiveEnergyBurned",
//            HKQuantityType.quantityType(forIdentifier: .stepCount): "includeStepCountUpload",
//            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning): "includeDistanceWalkingRunning",
//            HKQuantityType.quantityType(forIdentifier: .vo2Max): "includeVo2Max",
//            HKQuantityType.quantityType(forIdentifier: .heartRate): "includeHeartRate",
//            HKQuantityType.quantityType(forIdentifier: .restingHeartRate): "includeRestingHeartRate",
//            HKQuantityType.quantityType(forIdentifier: .oxygenSaturation): "includeOxygenSaturation",
//            HKQuantityType.quantityType(forIdentifier: .respiratoryRate): "includeRespiratoryRate",
//            HKQuantityType.quantityType(forIdentifier: .walkingHeartRateAverage): "includeWalkingHeartRateAverage"
//        ]
//        var toggleNameToBoolMapping: [String: Bool] = PrivacyModule().getCurrentToggles()
//        
//        if let variableName = sampleToToggleNameMapping[quantityType] {
//            let response: Bool = toggleNameToBoolMapping[variableName] ?? false
//            
//            if !response {
//                return
//            }
//        } else {
//            return
//        }
        
        
        // convert the startDate of the HKSample to local time
        let timeIndex = getTimeIndex(startDate: sample.startDate, endDate: sample.endDate)
        let effectiveTimestamp = sample.startDate.localISOFormat()
        
        
        let path: String
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
            firestoreResource["time"] = timeIndex
            try await Firestore.firestore().document(path).setData(firestoreResource)
        } catch {
            print("Failed to set data in Firestore: \(error.localizedDescription)")
        }
    }
    
    func remove(sample: HKDeletedObject) async { }
}
