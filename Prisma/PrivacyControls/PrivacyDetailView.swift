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


struct PrivacyDetailView: View {
    @Environment(PrivacyModule.self) var privacyModule
    @State var privacyDetailViewModel: PrivacyDetailViewModel
    let sampleType: HKSampleType
    
    
    var body: some View {
        Form {
            descriptionSection
            toggleSection
            PrivacyDetailHideByTimeRangeSection(sampleType: sampleType)
            PrivacyDetailHideByListSection(sampleType: sampleType)
        }
            .environment(privacyDetailViewModel)
            .navigationTitle(sampleType.title.localizedString())
    }
    
    @ViewBuilder private var descriptionSection: some View {
        Section(header: Text("About")) {
            Text(sampleType.extendedDescription)
        }
    }
    
    @ViewBuilder private var toggleSection: some View {
        Section(header: Text("Allow Data Upload")) {
            Toggle(isOn: privacyModule.binding(for: sampleType)) {
                Text(sampleType.title)
            }
        }
    }
    
    
    init(_ sampleType: HKSampleType, standard: PrismaStandard) {
        self.sampleType = sampleType
        self._privacyDetailViewModel = State(
            wrappedValue: PrivacyDetailViewModel(sampleType: sampleType, standard: standard)
        )
    }
}


#Preview {
    let standard = PrismaStandard()
    
    return NavigationStack {
        PrivacyDetailView(HKQuantityType(.stepCount), standard: standard)
            .previewWith(standard: standard) {
                PrivacyModule(sampleTypes: PrismaDelegate.healthKitSampleTypes)
            }
    }
}
