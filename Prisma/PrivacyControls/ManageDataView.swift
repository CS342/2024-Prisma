//
//  ManageDataView.swift
//  Prisma
//
//  Created by Evelyn Hur on 2/28/24.
//

import SwiftUI

struct ManageDataView: View {
    @Environment(PrivacyModule.self) private var privacyModule
    var body: some View {
        NavigationView {
            List(privacyModule.dataCategoryItems, id: \.name) { item in
                Text(item.name)
                // DeleteDataView(item: item.name)
//                NavigationLink(destination: DeleteDataView()) {
//                    HStack {
//                        Image(systemName: item.iconName.wrappedValue)
//                            .resizable()
//                            .frame(width: 40, height: 40)
//                            .padding(.trailing, 8)
//                            .accessibility(label: Text("accessibility text temp"))
//                        
//                        VStack(alignment: .leading) {
//                            Text(item.iconName.wrappedValue)
//                                .font(.headline)
//                            Text(item.enabledStatus.wrappedValue)
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                        }
//                    }
//                    .padding(.vertical, 4)
//                }
            }
            .navigationTitle("Manage All Data")
        }
    }
}

#Preview {
    ManageDataView()
}
