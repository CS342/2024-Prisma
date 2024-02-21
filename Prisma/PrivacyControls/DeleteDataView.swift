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

    
    var body: some View {
        NavigationView {
                    Form {
                        Toggle("Include Step Count Upload", isOn: $privacyModule.includeStepCountUpload)
                        Toggle("Include Active Energy Burned", isOn: $privacyModule.includeActiveEnergyBurned)
                        Toggle("Include Distance Walking Running", isOn: $privacyModule.includeDistanceWalkingRunning)
                        Toggle("Include Vo2 Max", isOn: $privacyModule.includeVo2Max)
                        Toggle("Include Heart Rate", isOn: $privacyModule.includeHeartRate)
                        Toggle("Include Resting Heart Rate", isOn: $privacyModule.includeRestingHeartRate)
                        Toggle("Include Oxygen Saturation", isOn: $privacyModule.includeOxygenSaturation)
                        Toggle("Include Respiratory Rate", isOn: $privacyModule.includeRespiratoryRate)
                        Toggle("Include Walking Heart Rate Average", isOn: $privacyModule.includeWalkingHRAverage)
                    }
                    .navigationBarTitle("Manage Health Data")
        }
    }
}

#Preview {
    DeleteDataView()
}
