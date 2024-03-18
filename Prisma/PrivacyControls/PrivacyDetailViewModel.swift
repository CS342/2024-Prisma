//
// This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import FirebaseFirestore
import HealthKit


@Observable
class PrivacyDetailViewModel {
    let sampleType: HKSampleType
    let standard: PrismaStandard
    var recentSamples: [QueryDocumentSnapshot] = []
    
    
    init(sampleType: HKSampleType, standard: PrismaStandard) {
        self.sampleType = sampleType
        self.standard = standard
    }
    
    
    func reload() async {
        recentSamples = await standard.fetchRecentSamples(for: sampleType)
    }
}
