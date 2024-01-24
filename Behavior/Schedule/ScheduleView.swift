//
// This source file is part of the Behavior based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziAccount
import SpeziQuestionnaire
import SpeziScheduler
import SwiftUI


struct ScheduleView: View {
    @Environment(BehaviorScheduler.self) private var scheduler
    @Binding var presentingAccount: Bool
    
    
    private var relevantEventContexts: [EventContext] {
        scheduler.tasks
            .flatMap { task in
                task
                    .events(
                        from: Calendar.current.startOfDay(for: .now),
                        to: .numberOfEventsOrEndDate(
                            100,
                            Calendar.current.date(
                                byAdding: .init(day: 1), to: Calendar.current.startOfDay(for: .now)
                            ) ?? .now
                        )
                    )
                    .map { event in
                        EventContext(event: event, task: task)
                    }
            }
            .sorted()
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                if relevantEventContexts.isEmpty {
                    Text("Currently there are no surveys available, you will be notified about upcoming surveys.")
                        .multilineTextAlignment(.center)
                        .frame(idealWidth: .infinity)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.background.secondary)
                                .shadow(radius: 5)
                        }
                        .padding()
                } else {
                    ForEach(relevantEventContexts) { eventContext in
                        EventContextCard(
                            eventContext: eventContext
                        )
                    }
                }
            }
                .navigationTitle("SCHEDULE_LIST_TITLE")
                .toolbar {
                    if AccountButton.shouldDisplay {
                        AccountButton(isPresented: $presentingAccount)
                    }
                }
        }
    }
    
    
    init(presentingAccount: Binding<Bool>) {
        self._presentingAccount = presentingAccount
    }
}


#if DEBUG
#Preview("ScheduleView") {
    ScheduleView(presentingAccount: .constant(false))
        .previewWith(standard: BehaviorStandard()) {
            BehaviorScheduler()
        }
}
#endif
