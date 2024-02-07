//
//  This file implements functions necessary for push notifications to be implemented within the Prisma application.
//  Includes methods for monitoring token refresh, using methods from the PrismaStandard to upload them to a user's
//  collection in Firebase.
//
//  Created by Bryant Jimenez on 2/1/24.
//

import FirebaseCore
import FirebaseMessaging
import Spezi
import SwiftUI


class PrismaPushNotifications: NSObject, Module, LifecycleHandler, MessagingDelegate, UNUserNotificationCenterDelegate, EnvironmentAccessible {
    @StandardActor var standard: PrismaStandard
    @AppStorage(StorageKeys.pushNotificationsAllowed) var pushNotificationsAllowed = false
    
    override init() {}
     
    /// Prompts the user to allow notifications on their device, storing that result on disk to reference on app startup.
    func requestNotificationAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        // prompt the user to allow notifications
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { [self] granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
                return
            }
            // UIApplication methods must run on a main thread
            DispatchQueue.main.async {
                if granted {
                    self.pushNotificationsAllowed = true
                    // generate apns token, triggers didRegisterForRemoteNotificationsWithDeviceToken()
                    UIApplication.shared.registerForRemoteNotifications()
                } else {
                    self.pushNotificationsAllowed = false
                }
            }
        }
    }
    
    // MARK: - Token Management
    /// This function sets the messaging delegate in order to receive registration tokens.
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        Messaging.messaging().delegate = self
        return true
    }
    
    /// When the app successfully registers for remote notifications, it receives a device
    /// token from Apple's push notification service (APNs). The deviceToken parameter
    /// contains a unique identifier for the device, which the app uses to receive remote
    /// notifications. 
    ///
    /// We assign the APNs token received from Apple to the apnsToken property of the
    /// Messaging class provided by the Firebase SDK. Firebase uses this token to communicate with
    /// APNs and send notifications to the device.
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    
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
}
