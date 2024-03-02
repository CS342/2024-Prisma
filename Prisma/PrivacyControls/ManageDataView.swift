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

struct ManageDataView: View {
    
    //    var items = [
    //        Item(name: "Step Count", iconName: "figure.walk", status: "Enabled")
    //    ]
    
    @Bindable var privacyModule = PrivacyModule()
    Task {
        @Bindable var privacyModule = PrivacyModule()
        var items: [Item] = []
        for key in privacyModule.togglesMap.keys {
            let iconName = privacyModule.iconsMapping[key]
            let status = privacyModule.togglesMap[key] ?? false ? "Enabled" : "Disabled"
            items.append(Item(name: key, iconName: iconName, status: status))
        }
    }
    
    var body: some View {
        NavigationView {
            List(items, id: \.name) { item in
                // DeleteDataView(item: item.name)
                NavigationLink(destination: DeleteDataView()) {
                    HStack {
                        Image(systemName: item.iconName)
                            .resizable()
                            .frame(width: 40, height: 40)
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
