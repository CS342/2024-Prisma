//
// This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import FirebaseFirestore
import SpeziHealthKit
import SpeziViews
import SwiftUI


private struct PrivacyDetailHideByListRow: View {
    @Environment(PrismaStandard.self) private var standard
    
    private let sampleType: HKSampleType
    private let recentSample: QueryDocumentSnapshot
    
    @State private var markedAsHidden: Bool
    @State private var processing = false
    
    
    var body: some View {
        HStack {
            Label(
                title: {
                    Text(recentSample.documentID)
                },
                icon: {
                    Image(systemName: markedAsHidden ? "eye.slash" : "eye")
                        .accessibilityLabel(markedAsHidden ? "Hide Timestamp" : "Show Timestamp")
                        .foregroundStyle(markedAsHidden ? Color.gray : Color.accentColor)
                }
            )
                .opacity(processing ? 0.5 : 1.0)
            Spacer()
            if processing {
                ProgressView()
            }
        }
            .onTapGesture {
                guard !processing else {
                    return
                }
                
                Task {
                    do {
                        processing = true
                        try await standard.toggleHideFlag(
                            sampleType: sampleType,
                            documentId: recentSample.documentID,
                            alwaysHide: false
                        )
                        markedAsHidden.toggle()
                    } catch {
                        print("Could not toggle privacy control ...")
                    }
                    processing = false
                }
            }
    }
    
    
    init(sampleType: HKSampleType, recentSample: QueryDocumentSnapshot) {
        self.sampleType = sampleType
        self.recentSample = recentSample
        self._markedAsHidden = State(wrappedValue: (recentSample.data()["hideFlag"] as? Bool) ?? false)
    }
}


struct PrivacyDetailHideByListSection: View {
    @Environment(PrismaStandard.self) private var standard
    @Environment(PrivacyDetailViewModel.self) private var privacyDetailViewModel
    
    private let sampleType: HKSampleType
    
    
    var body: some View {
        Section(header: Text("Hide Data by Custom Range")) {
            ForEach(privacyDetailViewModel.recentSamples, id: \.documentID) { recentSample in
                PrivacyDetailHideByListRow(sampleType: sampleType, recentSample: recentSample)
            }
        }
            .task {
                await privacyDetailViewModel.reload()
            }
    }
    
    
    init(sampleType: HKSampleType) {
        self.sampleType = sampleType
    }
}


#Preview {
    List {
        PrivacyDetailHideByListSection(sampleType: HKQuantityType(.stepCount))
            .previewWith(standard: PrismaStandard()) {
                PrivacyModule(sampleTypes: PrismaDelegate.healthKitSampleTypes)
            }
    }
}
