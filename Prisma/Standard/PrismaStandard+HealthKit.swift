//
// This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import FirebaseFirestore
import HealthKitOnFHIR
import ModelsR4
import SpeziFirestore
import SpeziHealthKit

extension PrismaStandard {
    func getSampleIdentifier(sample: HKSample) -> String? {
        switch sample {
        case let quantitySample as HKQuantitySample:
            return quantitySample.quantityType.identifier
        case let categorySample as HKCategorySample:
            return categorySample.categoryType.identifier
        case is HKWorkout:
            //  return "\lcal(workout.workoutActivityType)"
            return "workout"
        // Add more cases for other HKSample subclasses if needed
        default:
            return nil
        }
    }

    /// Takes in HKSampleType and returns the corresponding identifier string
    ///
    /// - Parameters:
    ///   - sampleType: HKSampleType to find identifier for
    /// - Returns: A string for the sample type identifier.
    public func getSampleIdentifierFromHKSampleType(sampleType: HKSampleType) -> String? {
        if let quantityType = sampleType as? HKQuantityType {
            return quantityType.identifier
        } else if let categoryType = sampleType as? HKCategoryType {
            return categoryType.identifier
        } else if sampleType is HKWorkoutType {
            return "workout"
        }
        // Default case for other HKSampleTypes
        else {
            return "Unknown Sample Type"
        }
    }
    
    /// Adds a new `HKSample` to the Firestore.
    /// - Parameter response: The `HKSample` that should be added.
    func add(sample: HKSample) async {
        let identifier: String
        if let id = getSampleIdentifier(sample: sample) {
            identifier = id
        } else {
            print("Failed to upload HealtHkit sample. Unknown sample type: \(sample)")
            return
        }
        
        // convert the startDate of the HKSample to local time
        let timeIndex = constructTimeIndex(startDate: sample.startDate, endDate: sample.endDate)
        let effectiveTimestamp = sample.startDate.localISOFormat()
        
        
        // convert the startDate of the HKSample to local time
        let startDatetime = sample.startDate
        let effectiveTimestamp = startDatetime.toISOFormat()
//        let endDatetime = sample.endDate.toISOFormat()
        
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
    
    func addDeleteFlag(selectedTypeIdentifier: String, timestamp: String) async {
        let path: String
        
        do {
            // call getPath to get the path for this user, up until this specific quantityType
            path = try await getPath(module: .health(selectedTypeIdentifier)) + "raw/\(timestamp)"
            print("selectedindentifier:" + selectedTypeIdentifier)
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
