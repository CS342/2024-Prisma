//
// This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
// Created by Bryant Jimenez on 2/22/24.
//

import FirebaseFirestore
import Foundation

extension PrismaStandard {
    /// Stores the timestamp when a notification was received by
    /// the user's device to the specific notification document.
    ///
    /// - Parameter timestamp: The time which the notification was received by the device
    func addNotificationReceivedTimestamp(timeSent: String, timeReceived: String) async {
        // path = user_id/notifications/data/logs/YYYY-MM-DDThh:mm:ss.mss
        let path: String
        do {
            path = try await getPath(module: .notifications("logs")) + "\(timeSent)"
        } catch {
            print("Failed to define path: \(error.localizedDescription)")
            return
        }
        
        // try push to Firestore.
        do {
            try await Firestore.firestore().document(path).setData(["received": timeReceived])
        } catch {
            print("Failed to set data in Firestore: \(error.localizedDescription)")
        }
    }
    
    
    /// Stores the timestamp when a notification was opened by
    /// the user to the specific notification document.
    func addNotificationOpenedTimestamp(timeSent: String, timeOpened: String) async {
        // path = user_id/notifications/data/logs/YYYY-MM-DDThh:mm:ss.mss
        let path: String
        do {
            path = try await getPath(module: .notifications("logs")) + "\(timeSent)"
        } catch {
            print("Failed to define path: \(error.localizedDescription)")
            return
        }
        
        // try push to Firestore.
        do {
            try await Firestore.firestore().document(path).setData(["opened": timeOpened])
        } catch {
            print("Failed to set data in Firestore: \(error.localizedDescription)")
        }
    }
}
