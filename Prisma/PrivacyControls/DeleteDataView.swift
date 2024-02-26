//
//  DeleteDataView.swift
//  Prisma
//
//  Created by Evelyn Hur, Caroline Tran on 2/20/24.
//

import Foundation
import Spezi
import SwiftUI

struct DeleteDataView: View {
   @Bindable var privacyModule = PrivacyModule()
    @Environment(PrismaStandard.self) private var standard
    @State private var items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]

    
    var body: some View {
        NavigationView {
            List {
                // Display each item in the list
                ForEach(items, id: \.self) { item in
                    Text(item)
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
        items.remove(atOffsets: offsets) // Update the data model
        // if line 44 fails, the user will think it was deleted but it might not have been deleted in firestore
//        Task {
//            await standard.addDeleteFlag(quantityType: "stepcount", timestamp: "")
//        }
        // wait for addDeleteFlag to finish BEFORE showing that that piece of data was deleted on the UI side
    }
}

#Preview {
    DeleteDataView()
}
