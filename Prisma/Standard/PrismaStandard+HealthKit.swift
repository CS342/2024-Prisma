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
        let startDatetime = sample.startDate
        let effectiveTimestamp = startDatetime.localISOFormat()
        let endDatetime = sample.endDate.localISOFormat()
        
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
            try await Firestore.firestore().document(path).setData(firestoreResource)
        } catch {
            print("Failed to set data in Firestore: \(error.localizedDescription)")
        }
    }
    
    func remove(sample: HKDeletedObject) async { }
    
    func addDeleteFlag(selectedQuantityType: HKQuantityType, timestamp: String) async {
        let path: String
        
        do {
            // protect against nil values for the quantityType identifier
            guard let identifier = HKQuantityType.quantityType(forIdentifier: .stepCount)?.identifier else {
                print("Error: Quantity type identifier is nil.")
                return
            }
            // call getPath to get the path for this user, up until this specific quantityType
            path = try await getPath(module: .health(identifier)) + "/raw/\(timestamp)"

            print("PATH FROM GET PATH: " + path)
        } catch {
            print("Failed to define path: \(error.localizedDescription)")
            return
        }
        
        // try push to Firestore.
        do {
            // add another key-value pair field for the delete flag
            // merge new key-value with pre-existing data instead of overwriting it
            let newData = ["deleteFlag": "true"]
            try await Firestore.firestore().document(path).setData(newData, merge: true)
            print("Successfully set deleteFlag to true.")
        } catch {
            print("Failed to set data in Firestore: \(error.localizedDescription)")
        }
    }
}
