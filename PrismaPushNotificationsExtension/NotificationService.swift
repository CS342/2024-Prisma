//
// This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project.
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
// This file implements an extension to the Notification Service class, which is used to upload timestamps to 
// Firestore on receival of background notifications.
//
// Created by Bryant Jimenez on 2/1/24.
//

import FirebaseFirestore
import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
//            let receivedTimestamp = Date().toISOFormat(timezone: TimeZone(abbreviation: "UTC"))
//            if let sentTimestamp = request.content.userInfo["sent_timestamp"] as? String {
//                Task {
//                    await standard.addNotificationReceivedTimestamp(timeSent: sentTimestamp, timeReceived: receivedTimestamp)
//                }
//            } else {
//                print("Sent timestamp is not a string or is nil")
//            }
            
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}
