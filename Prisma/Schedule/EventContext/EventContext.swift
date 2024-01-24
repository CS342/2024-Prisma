//
// This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SpeziScheduler


struct EventContext: Comparable, Identifiable {
    static let eventTimeout: TimeInterval = 60 * 60 // Timeout for user to answer the question is 1 hour.
    
    let event: Event
    let task: SpeziScheduler.Task<PrismaTaskContext>
    
    
    var id: Event.ID {
        event.id
    }
    
    var active: Bool {
        event.due && event.scheduledAt.addingTimeInterval(EventContext.eventTimeout) > .now
    }
    
    var expired: Bool {
        event.due && event.scheduledAt.addingTimeInterval(EventContext.eventTimeout) < .now
    }
    
    
    static func < (lhs: EventContext, rhs: EventContext) -> Bool {
        lhs.event.scheduledAt < rhs.event.scheduledAt
    }
}
