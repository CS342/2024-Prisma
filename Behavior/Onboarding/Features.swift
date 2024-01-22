//
// This source file is part of the Behavior based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziOnboarding
import SwiftUI


struct Features: View {
    @Environment(OnboardingNavigationPath.self) private var onboardingNavigationPath
    
    
    var body: some View {
        Group {
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center, spacing: 0) {
                        Text("FEATURES_TITLE")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.accentColor)
                            .multilineTextAlignment(.center)
                        Spacer()
                        features
                        Spacer()
                        Spacer()
                        OnboardingActionsView("FEATURES_BUTTON") {
                            onboardingNavigationPath.nextStep()
                        }
                        Spacer()
                            .frame(height: 10)
                    }
                    .frame(minHeight: geometry.size.height)
                }
            }
            .padding(24)
        }
    }
    
    var features: some View {
        OnboardingInformationView(
            areas: [
                .init(
                    icon: Image(systemName: "applewatch"), // swiftlint:disable:this accessibility_label_for_image
                    title: "FEATURES_AREA1_TITLE",
                    description: "FEATURES_AREA1_DESCRIPTION"
                ),
                .init(
                    icon: Image(systemName: "message.fill"), // swiftlint:disable:this accessibility_label_for_image
                    title: "FEATURES_AREA2_TITLE",
                    description: "FEATURES_AREA2_DESCRIPTION"
                ),
                .init(
                    icon: Image(systemName: "chart.dots.scatter"), // swiftlint:disable:this accessibility_label_for_image
                    title: "FEATURES_AREA3_TITLE",
                    description: "FEATURES_AREA3_DESCRIPTION"
                )
            ]
        )
    }
}


#if DEBUG
#Preview {
    OnboardingStack {
        Features()
    }
}
#endif
