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
    
    func daysInMonth(month: Int, year: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    // swiftlint:disable discouraged_optional_collection
    func getRange(start: Any?, end: Any?, maxValue: Int, startValue: Int = 0) -> [Int]? {
        guard let startInt = start as? Int, let endInt = end as? Int else {
            return nil
        }
        
        if startInt <= endInt {
            return Array(startInt...endInt)
        } else {
            return Array(startInt...maxValue) + Array(startValue...endInt)
        }
    }
    
    // swiftlint:disable function_body_length
    func getTimeIndex(sample: HKSample) -> [String: Any?] {
        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: sample.startDate)
        let endComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: sample.endDate)
        let isRange = sample.startDate != sample.endDate
        
        var timeIndex: [String: Any?] = [
            "range": isRange,
            "year.start": startComponents.year,
            "month.start": startComponents.month,
            "day.start": startComponents.day,
            "hour.start": startComponents.hour,
            "minute.start": startComponents.minute,
            // number of total minutes elapsed in the day, between [0, 1439]
            // flatMap defaults to nil if either .hour or .minute are nil
            "dayMinute.start": startComponents.hour.flatMap { hour in
                startComponents.minute.map { minute in
                    hour * 60 + minute
                }
            },
            // index of the 15min bucket that this sample falls into, between [0, 95]
            "15minBucket.start": startComponents.hour.flatMap { hour in
                startComponents.minute.map { minute in
                    hour * 4 + minute / 15
                }
            },
            "second.start": startComponents.second
        ]
        
        if isRange { // only write end date and range if it is a range type
            timeIndex["year.end"] = endComponents.year
            timeIndex["month.end"] = endComponents.month
            timeIndex["day.end"] = endComponents.day
            timeIndex["hour.end"] = endComponents.hour
            timeIndex["minute.end"] = endComponents.minute
            timeIndex["dayMinute.end"] = endComponents.hour.flatMap { hour in
                endComponents.minute.map { minute in
                    hour * 60 + minute
                }
            }
            timeIndex["15minBucket.end"] = endComponents.hour.flatMap { hour in
                endComponents.minute.map { minute in
                    hour * 4 + minute / 15
                }
            }
            timeIndex["second.end"] = endComponents.second
            
            timeIndex["year.range"] = getRange(start: timeIndex["year.start"] as? Int, end: timeIndex["year.end"] as? Int, maxValue: Int.max)
            timeIndex["month.range"] = getRange(
                                            start: timeIndex["month.start"] as? Int,
                                            end: timeIndex["month.end"] as? Int,
                                            maxValue: 12,
                                            startValue: 1 // months are 1-indexed
                                       )
            timeIndex["day.range"] = getRange(
                                            start: timeIndex["day.start"] as? Int,
                                            end: timeIndex["day.end"] as? Int,
                                            maxValue: daysInMonth(month: startComponents.month ?? 0, year: startComponents.year ?? 0),
                                            startValue: 1 // days are 1-indexed
                                     )
            timeIndex["hour.range"] = getRange(
                                            start: timeIndex["hour.start"] as? Int,
                                            end: timeIndex["hour.end"] as? Int,
                                            maxValue: 23
                                      )
            timeIndex["minute.range"] = getRange(
                                            start: timeIndex["minute.start"] as? Int,
                                            end: timeIndex["minute.end"] as? Int,
                                            maxValue: 59
                                        )
            timeIndex["dayMinute.range"] = getRange(
                                            start: timeIndex["dayMinute.start"] as? Int,
                                            end: timeIndex["dayMinute.end"] as? Int,
                                            maxValue: 1439
                                        )
            timeIndex["15minBucket.range"] = getRange(
                                            start: timeIndex["15minBucket.start"] as? Int,
                                            end: timeIndex["15minBucket.end"] as? Int,
                                            maxValue: 95
                                        )
            timeIndex["second.range"] = getRange(start: timeIndex["second.start"] as? Int, end: timeIndex["second.end"] as? Int, maxValue: 59)
        }
        
        return timeIndex
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
        let timeIndex = getTimeIndex(sample: sample)
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
