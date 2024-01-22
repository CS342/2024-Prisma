//
// This source file is part of the Behavior based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SpeziScheduler


/// A `Scheduler` using the ``BehaviorTaskContext`` to schedule and manage tasks and events in the
/// Behavior.
typealias BehaviorScheduler = Scheduler<BehaviorTaskContext>


extension BehaviorScheduler {
    static var socialSupportTask: SpeziScheduler.Task<BehaviorTaskContext> {
        let dateComponents: DateComponents
        if FeatureFlags.testSchedule {
            // Adds a task at the current time for UI testing if the `--testSchedule` feature flag is set
            dateComponents = DateComponents(
                hour: Calendar.current.component(.hour, from: .now),
                minute: Calendar.current.component(.minute, from: .now)
            )
        } else {
            // For the normal app usage, we schedule the task for every day at 8:00 AM
            dateComponents = DateComponents(hour: 8, minute: 0)
        }
        
        // Replaced the localized titles/descriptions for prev questionnaire to the new questionnaire.
        // Scheduling is kept the same for now.
        // Path for JSON of modified questionnaire is now inputted.
        return Task(
            title: String(localized: "EMOTION_QUESTIONNAIRE_TITLE"),
            description: String(localized: "EMOTION_QUESTIONNAIRE_DESCRIPTION"),
            schedule: Schedule(
                start: Calendar.current.startOfDay(for: Date()),
                repetition: .matching(dateComponents),
                end: .numberOfEvents(365)
            ),
            notifications: true,
            context: BehaviorTaskContext.questionnaire(Bundle.main.questionnaire(withName: "EmotionQuestionnaire"))
        )
    }

    /// Creates a default instance of the ``BehaviorScheduler`` by scheduling the tasks listed below.
    convenience init() {
        self.init(tasks: [Self.socialSupportTask])
    }
}
