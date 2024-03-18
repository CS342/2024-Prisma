//
// This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziHealthKit
import SpeziViews
import SwiftUI


struct PrivacyDetailHideByTimeRangeSection: View {
    @Environment(PrismaStandard.self) private var standard
    @Environment(PrivacyDetailViewModel.self) private var privacyDetailViewModel
    
    let sampleType: HKSampleType
    
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    
    var body: some View {
        Section(header: Text("Hide Data by Custom Range")) {
            VStack {
                DatePicker("Start date", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                DatePicker("End date", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
                Divider()
                AsyncButton(
                    action: {
                        await standard.hideSamples(sampleType: sampleType, startDate: startDate, endDate: endDate)
                        await privacyDetailViewModel.reload()
                    },
                    label: {
                        Text("Hide")
                            .frame(maxWidth: .infinity, minHeight: 30)
                    }
                )
                    .buttonStyle(.borderedProminent)
            }
        }
    }
    
    
    init(sampleType: HKSampleType) {
        self.sampleType = sampleType
    }
}


#Preview {
    List {
        PrivacyDetailHideByTimeRangeSection(sampleType: HKQuantityType(.stepCount))
            .previewWith(standard: PrismaStandard()) {
                PrivacyModule(sampleTypes: PrismaDelegate.healthKitSampleTypes)
            }
    }
}
