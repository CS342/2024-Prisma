//
//  DeleteDataView.swift
//  Prisma
//
//  Created by Evelyn Hur, Caroline Tran on 2/20/24.
//

import FirebaseFirestore
import Foundation
import SpeziHealthKit
import Spezi
import SwiftUI

struct DeleteDataView: View {
//    @Environment(PrivacyModule.self) private var privacyModule
    @Environment(PrismaStandard.self) private var standard
    @State private var timeArrayStatic = ["2023-11-14T20:39:44.467", "2023-11-14T20:41:00.000", "2023-11-14T20:42:00.000"]
//    var timeArray = getLastTimestamps(quantityType: "stepcount")
    
    // read in most recent time stamps from Matt's data
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
    func deleteItems(at offsets: IndexSet) {
        // grab timestamp and then send it to addDelete Flag
        timeArrayStatic.remove(atOffsets: offsets) // Update the data model
        // if line 44 fails, the user will think it was deleted but it might not have been deleted in firestore

        Task {
            // incorporate a mapping of HKQuantityTypes to strings in UI view
            // helps identify different categories later on
            guard let dataQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
                print("Error: Quantity type identifier is nil.")
                return
            }
            await standard.addDeleteFlag(selectedQuantityType: dataQuantityType, timestamp: "2023-11-14T20:39:44.467")
        }
        // Next steps: 
            // pull quantityType and timestamp from user selection on ui
            // wait for addDeleteFlag to finish BEFORE showing that that piece of data was deleted on the UI side
    }
    
}

#Preview {
    DeleteDataView()
}
