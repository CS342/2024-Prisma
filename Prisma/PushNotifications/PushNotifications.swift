//
// This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project.
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
// This file implements functions necessary for push notifications to be implemented within the Prisma application.
// Includes methods for monitoring token refresh, using methods from the PrismaStandard to upload them to a user's
// collection in Firebase.
//
// Created by Bryant Jimenez on 2/1/24.
//

import FirebaseCore
import FirebaseMessaging
import Spezi
import SpeziFirebaseConfiguration
import SwiftUI


class PrismaPushNotifications: NSObject, Module, NotificationHandler, NotificationTokenHandler, MessagingDelegate,
                               UNUserNotificationCenterDelegate, EnvironmentAccessible {
    @Application(\.registerRemoteNotifications)
    var registerRemoteNotifications

    @StandardActor var standard: PrismaStandard
    
    @Dependency private var configureFirebaseApp: ConfigureFirebaseApp
    
    @AppStorage(StorageKeys.pushNotificationsAllowed) var pushNotificationsAllowed = false
    
    override init() {}
    
    
    func configure() {
        Messaging.messaging().delegate = self
    }
    
    ///
    func handleNotificationsAllowed() async throws {
        let deviceToken = try await registerRemoteNotifications()
        print("APNS registration token: \(String(describing: deviceToken))")
//
//        let tokenDict: [String: Data] = ["apns_token": deviceToken ?? ""]
//        NotificationCenter.default.post(
//            name: Notification.Name("FCMToken"),
//            object: nil,
//            userInfo: tokenDict
//        )
        
//        await standard.storeToken(token: deviceToken)
        
    }
    
    func receiveUpdatedDeviceToken(_ deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    
    func receiveRemoteNotification(_ remoteNotification: [AnyHashable : Any]) async -> BackgroundFetchResult {
        .noData
    }
    
    func receiveIncomingNotification(_ notification: UNNotification) async -> UNNotificationPresentationOptions? {
        nil
    }
    
    func handleNotificationAction(_ response: UNNotificationResponse) async {
        print("...")
    }
    
    
//    /// Handle remote notification when the app is running in background. For now uploads a timestamp of when notification received to firestore.
//    func receiveRemoteNotification(_ remoteNotification: [AnyHashable : Any]) async -> BackgroundFetchResult {
//        print(remoteNotification)
//        // get current time and upload to firestore
//        //        let currentTime = Date().toISOFormat()
//        //        Task {
//        //            await standard.addNotificationReceivedTimestamp(timestamp: currentTime)
//        //        }
//        //
//        //        // In the future, if different actions desired to be completed in the background based on notification data received,
//        //        // handle that functionality and return any of .newData, .noData, .failed. For now, no new data retrieved
//        //        // from the background fetch.
//        return BackgroundFetchResult.noData
//    }
    
//    func handleNotificationAction(_ response: UNNotificationResponse) async {
//        print("handleNotifAction")
//    }
//    
//    
//    func receiveIncomingNotification(_ notification: UNNotification) async -> UNNotificationPresentationOptions? {
//        return [.badge, .banner, .sound, .list]
//    }
    
    
    
    
    
    
    /// This function listens for token refreshes and updates the specific user token to Firestore.
    /// This callback is fired at each app startup and whenever a new token is generated.
    ///
    /// Token refreshes may occur when:
    /// - the app is restored on a new device
    /// - the user uninstalls/reinstall the app
    /// - the user clears app data.
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        print("Firebase registration token: \(String(describing: fcmToken))")
        let tokenDict: [String: String] = ["apns_token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: tokenDict
        )
        
        // Update the token in Firestore:
        
        // The standard is an actor, which protects against data races and conforms to
        // immutable data practice
        
        // get into new asynchronous context and execute
        Task {
            await standard.storeToken(token: fcmToken)
        }
        
    }
    
    
    /// This function processes incoming remote notifications for the Prisma app.
    /// The system calls this method when Prisma is running either in the foreground or background. When a
    /// remote notification is received, we write a timestamp to the notification document in Firestore indicating that
    /// the notification was received.
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
//        print(userInfo)
//        // get current time
//        let currentTime = Date().localISOFormat()
//        Task {
//            await standard.addNotificationReceivedTimestamp(timestamp: currentTime)
//        }
//        
//        // In the future, if different actions desired to be completed in the background based on notification data received,
//        // handle that functionality and return any of .newData, .noData, .failed. For now, no new data retrieved
//        // from the background fetch.
//        return .noData
//    }
    
}
