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


struct EventContextCard: View {
    let eventContext: EventContext
    
    @Environment(PrismaStandard.self) private var standard
    
    @State private var presentedContext: EventContext?
    
    
    var body: some View {
        EventContextView(eventContext: eventContext)
            .padding(.vertical, 10)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.background.secondary)
                    .shadow(radius: 5)
            }
            .padding()
            .onTapGesture {
                // Event must be scheduled before now, not complete, and not expired
                if eventContext.active {
                    presentedContext = eventContext
                }
            }
            // Grey out if upcoming
            .opacity(eventContext.event.scheduledAt < .now ? 1.0 : 0.5)
            .sheet(item: $presentedContext) { presentedContext in
                destination(withContext: presentedContext)
            }
    }
    
    private func destination(withContext eventContext: EventContext) -> some View {
        @ViewBuilder var destination: some View {
            switch eventContext.task.context {
            case let .questionnaire(questionnaire):
                QuestionnaireView(questionnaire: questionnaire) { result in
                    presentedContext = nil
                    
                    guard case let .completed(response) = result else {
                        return // user cancelled the task
                    }
                    
                    eventContext.event.complete(true)
                    await standard.add(response: response)
                }
            case .test:
                Text("")
            }
        }
        return destination
    }
}
