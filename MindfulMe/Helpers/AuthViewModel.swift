import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestore


struct Question: Codable {
    let title: String
    let answer: String
    let options: [String]
}
protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            DispatchQueue.main.async {
                self.userSession = result.user
            }
            await fetchUser()
        } catch {
            print("DEBUG: Failed to sign in with error \(error.localizedDescription)")
            throw error
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            DispatchQueue.main.async {
                self.userSession = result.user
            }
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
            throw error
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.userSession = nil
                self.currentUser = nil
            }
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        do {
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
            DispatchQueue.main.async {
                self.currentUser = try? snapshot.data(as: User.self)
            }
        } catch {
            print("DEBUG: Failed to fetch user with error \(error.localizedDescription)")
        }
    }
    func fetchRandomQuestions(completion: @escaping ([Question]) -> Void) {
            let db = Firestore.firestore()
            
            db.collection("questions").getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching questions: \(error.localizedDescription)")
                    completion([])
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No questions found")
                    completion([])
                    return
                }
                
                // Map Firestore documents to Question objects
                let allQuestions: [Question] = documents.compactMap { doc in
                    return try? doc.data(as: Question.self)
                }
                
                // Shuffle and pick 8 random questions
                let randomQuestions = allQuestions.shuffled().prefix(8)
                
                // Return the random questions
                completion(Array(randomQuestions))
            }
        }
}
