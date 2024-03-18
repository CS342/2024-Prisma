//
// This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project.
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Firebase
import FirebaseFirestore
import UserNotifications


/// This file implements an extension to the Notification Service class, which is used to upload timestamps to Firestore on receival of background notifications.
class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        FirebaseApp.configure()
        
        do {
            try Auth.auth().useUserAccessGroup(Constants.keyChainGroup)
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
