//
// This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import HealthKit


extension HKSampleType {
    var systemImage: String {
        switch self.identifier {
        case HealthKit.HKQuantityType(.stepCount).identifier:
            "shoeprints.fill"
        case HealthKit.HKQuantityType(.distanceWalkingRunning).identifier:
            "figure.walk"
        case HealthKit.HKQuantityType(.basalEnergyBurned).identifier:
            "fork.knife.circle"
        case HealthKit.HKQuantityType(.activeEnergyBurned).identifier:
            "flame"
        case HealthKit.HKQuantityType(.flightsClimbed).identifier:
            "figure.stairs"
        case HealthKit.HKQuantityType(.appleExerciseTime).identifier:
            "figure.run.square.stack"
        case HealthKit.HKQuantityType(.appleMoveTime).identifier:
            "figure.cooldown"
        case HealthKit.HKQuantityType(.appleStandTime).identifier:
            "figure.stand"
        case HealthKit.HKQuantityType(.heartRate).identifier:
            "waveform.path.ecg"
        case HealthKit.HKQuantityType(.restingHeartRate).identifier:
            "arrow.down.heart"
        case HealthKit.HKQuantityType(.heartRateVariabilitySDNN).identifier:
            "chart.line.uptrend.xyaxis"
        case HealthKit.HKQuantityType(.walkingHeartRateAverage).identifier:
            "figure.walk.motion"
        case HealthKit.HKQuantityType(.oxygenSaturation).identifier:
            "drop.degreesign"
        case HealthKit.HKQuantityType(.respiratoryRate).identifier:
            "lungs.fill"
        case HealthKit.HKQuantityType(.bodyTemperature).identifier:
            "medical.thermometer"
        case HealthKit.HKCategoryType(.sleepAnalysis).identifier:
            "bed.double.fill"
        case HKWorkoutType.workoutType().identifier:
            "figure.strengthtraining.functional"
        default:
            "questionmark.circle"
        }
    }
    
    var title: LocalizedStringResource {
        switch self.identifier {
        case HealthKit.HKQuantityType(.stepCount).identifier:
            "Step Count"
        case HealthKit.HKQuantityType(.distanceWalkingRunning).identifier:
            "Distance Walking Running"
        case HealthKit.HKQuantityType(.basalEnergyBurned).identifier:
            "Resting Energy Burned"
        case HealthKit.HKQuantityType(.activeEnergyBurned).identifier:
            "Active Energy Burned"
        case HealthKit.HKQuantityType(.flightsClimbed).identifier:
            "Flights Climbed"
        case HealthKit.HKQuantityType(.appleExerciseTime).identifier:
            "Exercise Time"
        case HealthKit.HKQuantityType(.appleMoveTime).identifier:
            "Move Time"
        case HealthKit.HKQuantityType(.appleStandTime).identifier:
            "Stand Time"
        case HealthKit.HKQuantityType(.heartRate).identifier:
            "Heart Rate"
        case HealthKit.HKQuantityType(.restingHeartRate).identifier:
            "Resting Heart Rate"
        case HealthKit.HKQuantityType(.heartRateVariabilitySDNN).identifier:
            "Heart Rate Variability"
        case HealthKit.HKQuantityType(.walkingHeartRateAverage).identifier:
            "Walking Heart Rate Average"
        case HealthKit.HKQuantityType(.oxygenSaturation).identifier:
            "Oxygen Saturation"
        case HealthKit.HKQuantityType(.respiratoryRate).identifier:
            "Respiratory Rate"
        case HealthKit.HKQuantityType(.bodyTemperature).identifier:
            "Body Temperature"
        case HealthKit.HKCategoryType(.sleepAnalysis).identifier:
            "Sleep Analysis"
        case HKWorkoutType.workoutType().identifier:
            "Workout"
        default:
            "Unknown HealthKit Type"
        }
    }
    
    var extendedDescription: LocalizedStringResource {
        switch self.identifier {
        case HealthKit.HKQuantityType(.stepCount).identifier:
            "STEP_COUNT_DESCRIPTION"
        case HealthKit.HKQuantityType(.distanceWalkingRunning).identifier:
            "DISTANCE_WALKING_DESCRIPTION"
        case HealthKit.HKQuantityType(.basalEnergyBurned).identifier:
            "BASAL_ENERGY_BURNED_DESCRIPTION"
        case HealthKit.HKQuantityType(.activeEnergyBurned).identifier:
            "ACTIVE_ENERGY_BURNED_DESCRIPTION"
        case HealthKit.HKQuantityType(.flightsClimbed).identifier:
            "FLIGHTS_CLIMBED_DESCRIPTION"
        case HealthKit.HKQuantityType(.appleExerciseTime).identifier:
            "APPLE_EXERCISE_TIME_DESCRIPTION"
        case HealthKit.HKQuantityType(.appleMoveTime).identifier:
            "APPLE_MOVE_TIME_DESCRIPTION"
        case HealthKit.HKQuantityType(.appleStandTime).identifier:
            "APPLE_STAND_TIME_DESCRIPTION"
        case HealthKit.HKQuantityType(.heartRate).identifier:
            "HEART_RATE_DESCRIPTION"
        case HealthKit.HKQuantityType(.restingHeartRate).identifier:
            "RESTING_HEART_RATE_DESCRIPTION"
        case HealthKit.HKQuantityType(.heartRateVariabilitySDNN).identifier:
            "HEART_RATE_VARIABILITY_SDNN_DESCRIPTION"
        case HealthKit.HKQuantityType(.walkingHeartRateAverage).identifier:
            "WALKING_HEART_RATE_AVERAGE_DESCRIPTION"
        case HealthKit.HKQuantityType(.oxygenSaturation).identifier:
            "OXYGEN_SATURATION_DESCRIPTION"
        case HealthKit.HKQuantityType(.respiratoryRate).identifier:
            "RESPIRATORY_RATE_DESCRIPTION"
        case HealthKit.HKQuantityType(.bodyTemperature).identifier:
            "BODY_TEMPERATURE_DESCRIPTION"
        case HealthKit.HKCategoryType(.sleepAnalysis).identifier:
            "SLEEP_ANALYSIS_DESCRIPTION"
        case HKWorkoutType.workoutType().identifier:
            "WORKOUT_DESCRIPTION"
        default:
            "Unknown HealthKit Type"
        }
    }
}
