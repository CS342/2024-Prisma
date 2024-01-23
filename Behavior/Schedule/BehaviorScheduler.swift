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

/// These are placeholder surveys that should be replaced with project-relevant surveys later!
extension BehaviorScheduler {
    convenience init() {
        self.init(
            tasks: [
                Task(
                    title: String(localized: "MORNING_SURVEY_TITLE"),
                    description: String(localized: "MORNING_SURVEY_DESCRIPTION"),
                    schedule: Schedule(
                        start: Calendar.current.startOfDay(for: .now),
                        repetition: .randomBetween(start: .init(hour: 8, minute: 00), end: .init(hour: 11, minute: 00)), // Every Day between 8-11 AM
                        end: .numberOfEvents(356)
                    ),
                    notifications: true,
                    context: BehaviorTaskContext.questionnaire(Bundle.main.questionnaire(withName: "morning-en-US"))
                ),
                Task(
                    title: String(localized: "MID_DAY_SURVEY_TITLE"),
                    description: String(localized: "MID_DAY_SURVEY_DESCRIPTION"),
                    schedule: Schedule(
                        start: Calendar.current.startOfDay(for: .now),
                        repetition: .randomBetween(start: .init(hour: 11, minute: 00), end: .init(hour: 14, minute: 00)), // Every Day at 11-14 PM
                        end: .numberOfEvents(356)
                    ),
                    notifications: true,
                    context: BehaviorTaskContext.questionnaire(Bundle.main.questionnaire(withName: "mid-day-en-US"))
                ),
                Task(
                    title: String(localized: "AFTERNOON_SURVEY_TITLE"),
                    description: String(localized: "AFTERNOON_SURVEY_DESCRIPTION"),
                    schedule: Schedule(
                        start: Calendar.current.startOfDay(for: .now),
                        repetition: .randomBetween(start: .init(hour: 14, minute: 00), end: .init(hour: 17, minute: 00)), // Every Day at 14-17 PM
                        end: .numberOfEvents(356)
                    ),
                    notifications: true,
                    context: BehaviorTaskContext.questionnaire(Bundle.main.questionnaire(withName: "afternoon-en-US"))
                ),
                Task(
                    title: String(localized: "END_OF_THE_DAY_SURVEY_TITLE"),
                    description: String(localized: "END_OF_THE_DAY_SURVEY_DESCRIPTION"),
                    schedule: Schedule(
                        start: Calendar.current.startOfDay(for: .now),
                        repetition: .matching(.init(hour: 0, minute: 15)), // Every Day at 17:00 PM
                        end: .numberOfEvents(356)
                    ),
                    notifications: true,
                    context: BehaviorTaskContext.questionnaire(Bundle.main.questionnaire(withName: "end-of-day-en-US"))
                )
            ]
        )
    }
}
