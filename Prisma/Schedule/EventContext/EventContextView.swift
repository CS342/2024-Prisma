//
// This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//


import Combine
import Foundation
import SpeziQuestionnaire
import SpeziScheduler
import SwiftUI


struct EventContextView: View {
    let eventContext: EventContext
    
    @State private var timeSubtitle = Text("")
    @State private var icon = AnyView(ProgressView())
    @State private var cancellable: AnyCancellable?
    
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(eventContext.task.title)
                        .font(.headline)
                        .fontWeight(.bold)
                    timeSubtitle
                        .font(.subheadline)
                        .padding(.top, 0)
                        .foregroundColor(.gray)
                }
                Spacer()
                icon
            }
            
            // "Start Survey" button
            if eventContext.active {
                Text(eventContext.task.context.actionType)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.top, 8)
            }
        }
            .onChange(of: eventContext.event.state, initial: true) {
                updateViews()
            }
    }
    
    
    private func updateViews() {
        if case let .overdue(scheduledAt) = eventContext.event.state {
            let timeoutTime = scheduledAt.addingTimeInterval(EventContext.eventTimeout)
            if timeoutTime > .now {
                let timeUntilOverdue = Date.now.distance(to: timeoutTime)
                self.cancellable?.cancel()
                self.cancellable = nil
                self.cancellable = Timer.publish(every: timeUntilOverdue, on: .main, in: .default).autoconnect().sink { _ in
                    self.cancellable = nil
                    updateViews()
                }
            }
        }
        
        updateIcon()
        updateTimeSubtitle()
    }
    
    private func updateIcon() {
        switch eventContext.event.state {
        case .scheduled, .overdue:
            if !eventContext.expired {
                self.icon = AnyView(
                    Image(systemName: "clock.arrow.circlepath")
                        .foregroundColor(.gray)
                        .font(.system(size: 30))
                        .accessibilityLabel(Text("Upcoming notification"))
                )
            } else {
                self.icon = AnyView(
                    Image(systemName: "clock.badge.xmark.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 30))
                        .accessibilityLabel(Text("Expired notification"))
                )
            }
        case .completed:
            self.icon = AnyView(
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.accentColor)
                    .font(.system(size: 30))
                    .accessibilityLabel(Text("Completed notification"))
            )
        }
    }
    
    private func updateTimeSubtitle() {
        switch eventContext.event.state {
        case .scheduled:
            switch eventContext.task.schedule.repetition {
            case let .randomBetween(start, end):
                // Random time in an interval
                guard let startDate = Calendar.current.date(from: start),
                      let endDate = Calendar.current.date(from: end) else {
                    return
                }
                
                self.timeSubtitle = Text(
                    "Scheduled between \(Text(startDate, style: .time)) and \(Text(endDate, style: .time))"
                )
            case let .matching(date):
                // Specific time
                guard let scheduleDate = Calendar.current.date(from: date) else {
                    return
                }
                
                self.timeSubtitle = Text("Scheduled at \(Text(scheduleDate, style: .time))")
            }
        case let .overdue(scheduledAt):
            let timeoutTime = scheduledAt.addingTimeInterval(EventContext.eventTimeout)
            if timeoutTime > .now {
                self.timeSubtitle = Text("Expires in \(Text(timeoutTime, style: .relative))")
            } else {
                let expiryDate = eventContext.event.scheduledAt.addingTimeInterval(EventContext.eventTimeout)
                self.timeSubtitle = Text("Expired at \(Text(expiryDate, style: .time))")
            }
        case let .completed(completedAt, _):
            self.timeSubtitle = Text("Completed at \(Text(completedAt, style: .time))")
        }
    }
}


#if DEBUG
struct EventContextView_Previews: PreviewProvider {
    // We use a force unwrap in the preview as we can not recover from an error here
    // and the code will never end up in a production environment.
    // swiftlint:disable:next force_unwrapping
    private static let task = PrismaScheduler().tasks.first!
    
    
    static var previews: some View {
        EventContextView(
            eventContext: EventContext(
                // We use a force unwrap in the preview as we can not recover from an error here
                // and the code will never end up in a production environment.
                // swiftlint:disable:next force_unwrapping
                event: task.events(from: .now.addingTimeInterval(-60 * 60 * 24)).first!,
                task: task
            )
        )
            .padding()
    }
}
#endif
