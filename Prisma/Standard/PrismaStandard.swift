//
// This source file is part of the Stanford Prisma Application based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import FirebaseFirestore
import FirebaseStorage
import HealthKitOnFHIR
import OSLog
import PDFKit
import Spezi
import SpeziAccount
import SpeziFirebaseAccountStorage
import SpeziFirestore
import SpeziHealthKit
import SpeziMockWebService
import SpeziOnboarding
import SpeziQuestionnaire
import SwiftUI


actor PrismaStandard: Standard, EnvironmentAccessible, HealthKitConstraint, OnboardingConstraint, AccountStorageConstraint {
    enum PrismaStandardError: Error {
        case userNotAuthenticatedYet
    }
    
    /// modify this study id to change the Firebase bucket.
    static let STUDYID = "testing"

    private static var userCollection: CollectionReference {
        Firestore.firestore().collection("studies").document(STUDYID).collection("users")
    }

    @Dependency var mockWebService: MockWebService?
    @Dependency var accountStorage: FirestoreAccountStorage?

    @AccountReference var account: Account

    let logger = Logger(subsystem: "Prisma", category: "Standard")
    
    private var userDocumentReference: DocumentReference {
        get async throws {
            guard let details = await account.details else {
                throw PrismaStandardError.userNotAuthenticatedYet
            }

            return Self.userCollection.document(details.accountId)
        }
    }
    
    private var userBucketReference: StorageReference {
        get async throws {
            guard let details = await account.details else {
                throw PrismaStandardError.userNotAuthenticatedYet
            }

            return Storage.storage().reference().child("users/\(details.accountId)")
        }
    }


    init() {
        if !FeatureFlags.disableFirebase {
            _accountStorage = Dependency(wrappedValue: FirestoreAccountStorage(storeIn: PrismaStandard.userCollection))
        }
    }
    
    /// The firestore path for a given `Module`.
    /// - Parameter module: The `Module` that is requested.
    func getPath(module: Module) async throws -> String {
        let accountId: String
        if mockWebService != nil {
            accountId = "USER_ID"
        } else {
            guard let details = await account.details else {
                throw PrismaStandardError.userNotAuthenticatedYet
            }
            accountId = details.accountId
        }
        
        /// the "MODULE/SUBTYPE" string.
        var moduleText: String
        
        switch module {
        case .questionnaire(let type):
            // Questionnaire responses
            moduleText = "\(module.description)/\(type)"
        case .health(let type):
            // HealthKit observations
            moduleText = "\(module.description)/\(type.healthKitDescription)"
        }
        
        // studies/STUDY_ID/users/USER_ID/MODULE_NAME/SUB_TYPE/...
        return "studies/\(PrismaStandard.STUDYID)/users/\(accountId)/\(moduleText)/"
    }

    func deletedAccount() async throws {
        // delete all user associated data
        do {
            try await userDocumentReference.delete()
        } catch {
            logger.error("Could not delete user document: \(error)")
        }
    }
    
    /// Stores a user's specific token utilized for push notifications within their document directory.
    func storeToken(token: String) async {
    }
    
    /// Stores the given consent form in the user's document directory with a unique timestamped filename.
    ///
    /// - Parameter consent: The consent form's data to be stored as a `PDFDocument`.
    func store(consent: PDFDocument) async {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HHmmss"
        let dateString = formatter.string(from: Date())
        
        guard !FeatureFlags.disableFirebase else {
            guard let basePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                logger.error("Could not create path for writing consent form to user document directory.")
                return
            }
            
            let filePath = basePath.appending(path: "consentForm_\(dateString).pdf")
            consent.write(to: filePath)
            
            return
        }
        
        do {
            guard let consentData = consent.dataRepresentation() else {
                logger.error("Could not store consent form.")
                return
            }
            
            let metadata = StorageMetadata()
            metadata.contentType = "application/pdf"
            _ = try await userBucketReference.child("consent/\(dateString).pdf").putDataAsync(consentData, metadata: metadata)
        } catch {
            logger.error("Could not store consent form: \(error)")
        }
    }


    func create(_ identifier: AdditionalRecordId, _ details: SignupDetails) async throws {
        guard let accountStorage else {
            preconditionFailure("Account Storage was requested although not enabled in current configuration.")
        }
        try await accountStorage.create(identifier, details)
    }

    func load(_ identifier: AdditionalRecordId, _ keys: [any AccountKey.Type]) async throws -> PartialAccountDetails {
        guard let accountStorage else {
            preconditionFailure("Account Storage was requested although not enabled in current configuration.")
        }
        return try await accountStorage.load(identifier, keys)
    }

    func modify(_ identifier: AdditionalRecordId, _ modifications: AccountModifications) async throws {
        guard let accountStorage else {
            preconditionFailure("Account Storage was requested although not enabled in current configuration.")
        }
        try await accountStorage.modify(identifier, modifications)
    }

    func clear(_ identifier: AdditionalRecordId) async {
        guard let accountStorage else {
            preconditionFailure("Account Storage was requested although not enabled in current configuration.")
        }
        await accountStorage.clear(identifier)
    }

    func delete(_ identifier: AdditionalRecordId) async throws {
        guard let accountStorage else {
            preconditionFailure("Account Storage was requested although not enabled in current configuration.")
        }
        try await accountStorage.delete(identifier)
    }
}
