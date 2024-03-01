//
//  ManageDataView.swift
//  Prisma
//
//  Created by Evelyn Hur on 2/28/24.
//

import SwiftUI

struct Item {
    var name: String
    var iconName: String
    var status: String
}

// activeenergyburned, distancewalkingrunning, heartrate, oxygensaturation, respiratoryrate, restingheartrate, stepcount
var iconImages = ["figure.walk", "flame"]



struct ManageDataView: View {
//    @Bindable var privacyModule = PrivacyModule()
//    let items: [Item] = []
//    var index = 0
//    for (key, value) in togglesMapping {
//        items.append(Item(name: key, iconName: iconImages[index], status: value ? "Enabled" : "Disabled"))
//        index += 1
//    }
    let items = [
        Item(name: "Step Count", iconName: "figure.walk", status: "Enabled")
    ]
    /* use togglesMapping dictionary to get name (key) and status (value: bool)
    for
    */

    var body: some View {
            NavigationView {
                List(items, id: \.name) { item in
                    // DeleteDataView(item: item.name)
                    NavigationLink(destination: DeleteDataView()) {
                        HStack {
                            Image(systemName: item.iconName) // Using systemName for SF Symbols, replace with your image names if different
                                .resizable()
                                .frame(width: 40, height: 40) // Adjust size as needed
                                .padding(.trailing, 8)
                            
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.status)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .navigationTitle("Manage All Data")
            }
        }
    }

#Preview {
    ManageDataView()
}
