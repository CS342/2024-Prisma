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

extension PrismaStandard {
    /// Adds a new `HKSample` to the Firestore.
    /// - Parameter response: The `HKSample` that should be added.
    func add(sample: HKSample) async {
        guard let quantityType = sample.sampleType as? HKQuantityType else {
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
}
