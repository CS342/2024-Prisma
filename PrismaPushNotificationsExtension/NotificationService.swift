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

import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        FirebaseApp.configure()
        
        let accessGroup = "637867499T.edu.stanford.cs342.2024.behavior"
        do {
          try Auth.auth().useUserAccessGroup(accessGroup)
        } catch let error as NSError {
          print("Error changing user access group: %@", error)
        }
        
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        if let bestAttemptContent = bestAttemptContent {
            let path = request.content.userInfo["logs_path"] as? String ?? ""
            let receivedTimestamp = Date().toISOFormat(timezone: TimeZone(abbreviation: "UTC"))
            Firestore.firestore().document(path).setData(["received": receivedTimestamp], merge: true)
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

extension Date {
    /// converts Date object to ISO Format string. Can optionally pass in a time zone to convert it to.
    /// If no timezone is passed, it converts the Date object using the local time zone.
    func toISOFormat(timezone: TimeZone? = nil) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withTime, .withColonSeparatorInTime, .withFractionalSeconds]
        if let timezone = timezone {
            formatter.timeZone = timezone
        } else {
            formatter.timeZone = TimeZone.current
        }
        return formatter.string(from: self)
    }
}
