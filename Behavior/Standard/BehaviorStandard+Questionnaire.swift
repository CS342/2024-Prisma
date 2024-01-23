import FirebaseFirestore
import Spezi
import SpeziFirestore
import SpeziQuestionnaire

/// Implementation of the  `QuestionnaireConstraint` from the Spezi Standard.
extension BehaviorStandard {
    /// Adds a new `QuestionnaireResponse` to the Firestore.
    /// - Parameter response: The `QuestionnaireResponse` that should be added.
    func add(response: ModelsR4.QuestionnaireResponse) async {
        guard !FeatureFlags.disableFirebase else {
            return
        }

        // fetching the Spezi tag (e.g. "midday/affect").
        guard let tag = response.item?[0].linkId.value else {
            return
        }

        // extracts the first item as that is the id.
        let rootTag = String("\(tag)".split(separator: "/")[0])
        let effectiveTimestamp = Date().localISOFormat()
        
        let path: String
        do {
            path = try await getPath(module: .questionnaire(rootTag)) + "raw/\(effectiveTimestamp)"
        } catch {
            logger.error("Failed to set data in Firestore: \(error)")
            return
        }
        
        print(path)
        
        if let mockWebService {
            let id = response.identifier?.value?.value?.string ?? UUID().uuidString
            let jsonRepresentation = (try? String(data: JSONEncoder().encode(response), encoding: .utf8)) ?? ""
            try? await mockWebService.upload(path: "questionnaireResponse/\(id)", body: jsonRepresentation)
            return
        }
        
        // try push to Firestore.
        do {
            try await Firestore.firestore().document(path).setData(from: response)
        } catch {
            print("Failed to set data in Firestore: \(error.localizedDescription)")
        }
    }
}
