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
//    @Environment(PrismaStandard.self) private var standard
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
    func deleteItems(at offsets: IndexSet) {
        items.remove(atOffsets: offsets) // Update the data model
//        standard.addDeleteFlag(quantityType: "stepcount", timestamp: "")
    }
}

#Preview {
    DeleteDataView()
}
