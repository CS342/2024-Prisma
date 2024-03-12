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
    
    func writeToFirestore(sample: HKSample, identifier: String) async {
        // convert the startDate of the HKSample to local time
        let timeIndex = constructTimeIndex(startDate: sample.startDate, endDate: sample.endDate)
        let effectiveTimestamp = sample.startDate.toISOFormat()
        
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
            // encoder is used to convert swift types to a format that can be stored in firestore
            var firestoreResource = try encoder.encode(resource)
            firestoreResource["device"] = deviceName
            // timeIndex is a dictionary with time-related info (range, timezone, datetime.start, datetime.end)
            // timeIndex is added a field for this specific HK datapoint so we can just access this part to fetch/sort by time
            firestoreResource["time"] = timeIndex
            try await Firestore.firestore().document(path).setData(firestoreResource)
        } catch {
            print("Failed to set data in Firestore: \(error.localizedDescription)")
        }
    }
    
    /// Adds a new `HKSample` to the Firestore.
    /// - Parameter response: The `HKSample` that should be added.
    func add(sample: HKSample) async {
        let sampleList = [
            // Activity
            HKQuantityType(.stepCount),
            HKQuantityType(.distanceWalkingRunning),
            HKQuantityType(.basalEnergyBurned),
            HKQuantityType(.activeEnergyBurned),
            HKQuantityType(.flightsClimbed),
            HKQuantityType(.appleExerciseTime),
            HKQuantityType(.appleMoveTime),
            HKQuantityType(.appleStandTime),
            
            // Vital Signs
            HKQuantityType(.heartRate),
            HKQuantityType(.restingHeartRate),
            HKQuantityType(.heartRateVariabilitySDNN),
            HKQuantityType(.walkingHeartRateAverage),
            HKQuantityType(.oxygenSaturation),
            HKQuantityType(.respiratoryRate),
            HKQuantityType(.bodyTemperature),
            
            // Other events
            HKCategoryType(.sleepAnalysis),
            HKWorkoutType.workoutType()
        ]
//        let privacyModule = PrivacyModule(sampleTypeList: sampleList)

        @Dependency var privacyModule = PrivacyModule(sampleTypeList: sampleList)
        let toggleMap = await privacyModule.getHKSampleTypeMappings()
        
        let identifier: String
        if let id = getSampleIdentifier(sample: sample) {
            identifier = id
        } else {
            print("Failed to upload HealtHkit sample. Unknown sample type: \(sample)")
            return
        }
        if !(toggleMap[identifier] ?? false) {
            return
        }
        await writeToFirestore(sample: sample, identifier: identifier)
    }
    
    func remove(sample: HKDeletedObject) async { }
    
    func switchHideFlag(selectedTypeIdentifier: String, timestamp: String, alwaysHide: Bool) async {
        let firestore = Firestore.firestore()
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
        
        do {
            let document = firestore.document(path)
            let docSnapshot = try await document.getDocument()
            
            // If hideFlag exists, update its value
            if let hideFlagExists = docSnapshot.data()?["hideFlag"] as? Bool {
                if alwaysHide {
                    // If alwaysHide is true, always set hideFlag to true regardless of original value
                    try await document.setData(["hideFlag": true], merge: true)
                    print("AlwaysHide is enabled; set hideFlag to true.")
                } else {
                    // Toggle hideFlag if alwaysHide is not true
                    try await document.setData(["hideFlag": !hideFlagExists], merge: true)
                    print("Toggled hideFlag to \(!hideFlagExists).")
                }
            } else {
                // If hideFlag does not exist, create it and set to true
                try await document.setData(["hideFlag": true], merge: true)
                print("hideFlag was missing; set to true.")
            }
        } catch {
            print("Failed to set data in Firestore: \(error.localizedDescription)")
        }
    }

    func fetchTop10RecentTimeStamps(selectedTypeIdentifier: String) async -> [String] {
        let firestore = Firestore.firestore()
        let path: String
        var timestampsArr: [String] = []

        do {
            path = try await getPath(module: .health(selectedTypeIdentifier)) + "raw/"
            print("Selected identifier: " + selectedTypeIdentifier)
            print("Path from getPath: " + path)
            
            let querySnapshot = try await firestore.collection(path)
                .order(by: "issued", descending: true)
                .limit(to: 10)
                .getDocuments()

            for document in querySnapshot.documents {
                timestampsArr.append(document.documentID)
            }
            
            return timestampsArr
        } catch {
            print("Failed to fetch documents or define path: \(error.localizedDescription)")
            return []
        }
    }
    
    // Fetches timestamp based on documentID date
    func fetchCustomRangeTimeStamps(selectedTypeIdentifier: String, startDate: String, endDate: String) async -> [String] {
        let firestore = Firestore.firestore()
        let path: String
        var timestampsArr: [String] = []
        
        do {
            path = try await getPath(module: .health(selectedTypeIdentifier)) + "raw/"
            print("Selected identifier: " + selectedTypeIdentifier)
            print("Path from getPath: " + path)
            
            let querySnapshot = try await firestore.collection(path).getDocuments()
            
            for document in querySnapshot.documents {
                let documentID = document.documentID
                let documentDate = String(documentID.prefix(10))
                
                // check if documentID date is within the start and end date range
                if documentDate >= startDate && documentDate <= endDate {
                    timestampsArr.append(documentID)
                }
            }
            return timestampsArr
        } catch {
            if let firestoreError = error as? FirestoreError {
                print("Error fetching documents: \(firestoreError.localizedDescription)")
            } else {
                print("Unexpected error: \(error.localizedDescription)")
            }
            return []
        }
    }
}
