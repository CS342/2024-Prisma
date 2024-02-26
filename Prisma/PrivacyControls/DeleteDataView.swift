//
//  DeleteDataView.swift
//  Prisma
//
//  Created by Evelyn Hur, Caroline Tran on 2/20/24.
//

import Foundation
import Spezi
import SwiftUI
import FirebaseFirestore

struct DeleteDataView: View {
//    @Environment(PrivacyModule.self) private var privacyModule
    @Environment(PrismaStandard.self) private var standard
    @State private var timeArrayStatic = ["2023-11-14T20:39:44.467", "2023-11-14T20:41:00.000", "2023-11-14T20:42:00.000"]
//    var timeArray = getLastTimestamps(quantityType: "stepcount")

    

    // read in top 10 time stamps from Matt's data
    
    var body: some View {
        NavigationView {
            
            List {
                // Display each item in the list
                ForEach(timeArrayStatic, id: \.self) { timestamp in
                    Text(timestamp)
                }
                // Handle deletion
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("All Recorded Data")
            // Add an Edit button to enable deletion
            .navigationBarItems(trailing: EditButton())
        }
    }

    // Method to delete items
    // offset is where in the array that timestamp was deleted
    // read from firestore (firestore query), read in last 10 datapoints
    // display them on the screen (items array)
    // figure out how to pass timestamp to the addDeleteFlag
    
    // later step: how to add more data points (hit "show more")
    func deleteItems(at offsets: IndexSet) {
        // grab timestamp and then send it to addDelete Flag
        timeArrayStatic.remove(atOffsets: offsets) // Update the data model
        // if line 44 fails, the user will think it was deleted but it might not have been deleted in firestore
        Task {
            // QUESTION: how do we pass in the quantityType variable to getPath()?
            await standard.addDeleteFlag(quantityType: "stepcount", timestamp: "2023-11-14T20:39:44.467")
            print("added delete flag")
        }
        // wait for addDeleteFlag to finish BEFORE showing that that piece of data was deleted on the UI side
    }
    
//    func getLastTimestamps(quantityType: String) async -> [String] {
//        var path: String = ""
//
//        do {
//            path = try await standard.getPath(module: .health(quantityType)) + "raw/"
//        } catch {
//            print("Error retrieving user document: \(error)")
//        }
//
//        var lastTimestampsArr: [String] = []
//
//        do {
//            let querySnapshot = try await Firestore.firestore().collection(path).getDocuments()
//            for document in querySnapshot.documents {
//                lastTimestampsArr.append(document.documentID)
//                print("\(document.documentID) => \(document.data())")
//            }
//        } catch {
//            print("Error getting documents: \(error)")
//        }
//
//        return lastTimestampsArr
//    }
}

#Preview {
    DeleteDataView()
}
