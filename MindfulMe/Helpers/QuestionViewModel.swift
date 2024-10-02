import FirebaseFirestore

class QuestionViewModel: ObservableObject {
    @Published var randomQuestions: [Question] = []
    private var db = Firestore.firestore()

    func fetchRandomQuestions() {
        db.collection("questions").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching questions: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No questions found")
                return
            }

            let allQuestions = documents.compactMap { doc -> Question? in
                return try? doc.data(as: Question.self)
            }

            // Randomly select 8 questions
            let shuffledQuestions = allQuestions.shuffled().prefix(8)
            DispatchQueue.main.async {
                self.randomQuestions = Array(shuffledQuestions)
            }
        }
    }
}
