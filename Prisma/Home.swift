//
// This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import FirebaseAuth
import SpeziAccount
import SpeziMockWebService
import SwiftUI


struct HomeView: View {
    enum Tabs: String {
        case schedule
        case chat
        case contact
        case mockUpload
        case privacy
    }
    
    static var accountEnabled: Bool {
        !FeatureFlags.disableFirebase && !FeatureFlags.skipOnboarding
    }


    @AppStorage(StorageKeys.homeTabSelection) private var selectedTab = Tabs.schedule
    @Environment(PrismaStandard.self) private var standard
    @State private var presentingAccount = false

    
    var body: some View {
        TabView(selection: $selectedTab) {
            ChatView(presentingAccount: $presentingAccount)
                .tag(Tabs.chat)
                .tabItem {
                    Label("Chat", systemImage: "message.fill")
                }
            ScheduleView(presentingAccount: $presentingAccount)
                .tag(Tabs.schedule)
                .tabItem {
                    Label("SCHEDULE_TAB_TITLE", systemImage: "list.clipboard")
                }
            Contacts(presentingAccount: $presentingAccount)
                .tag(Tabs.contact)
                .tabItem {
                    Label("CONTACTS_TAB_TITLE", systemImage: "person.fill")
                }
            ManageDataView()
                .tag(Tabs.privacy)
                .tabItem {
                    Label("PRIVACY_CONTROLS_TITLE", systemImage: "gear")
                }
            if FeatureFlags.disableFirebase {
                MockUpload(presentingAccount: $presentingAccount)
                    .tag(Tabs.mockUpload)
                    .tabItem {
                        Label("MOCK_WEB_SERVICE_TAB_TITLE", systemImage: "server.rack")
                    }
            }
        }
            .sheet(isPresented: $presentingAccount) {
                AccountSheet()
            }
            .accountRequired(Self.accountEnabled) {
                AccountSheet()
            }
            .verifyRequiredAccountDetails(Self.accountEnabled)
            .task {
                await standard.authorizeAccessGroupForCurrentUser()
            }
    }
}


#if DEBUG
#Preview {
    let details = AccountDetails.Builder()
        .set(\.userId, value: "lelandstanford@stanford.edu")
        .set(\.name, value: PersonNameComponents(givenName: "Leland", familyName: "Stanford"))
    
    return HomeView()
        .previewWith(standard: PrismaStandard()) {
            PrismaScheduler()
            MockWebService()
            AccountConfiguration(building: details, active: MockUserIdPasswordAccountService())
        }
}

#Preview {
    CommandLine.arguments.append("--disableFirebase") // make sure the MockWebService is displayed
    return HomeView()
        .previewWith(standard: PrismaStandard()) {
            PrismaScheduler()
            MockWebService()
            AccountConfiguration {
                MockUserIdPasswordAccountService()
            }
        }
}
#endif
