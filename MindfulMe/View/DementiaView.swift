import SwiftUI

struct DementiaView: View {
    @State private var isMessageShown: Bool = true
    @State private var questions: [Question] = []
    @State private var currentQuestionIndex: Int = 0
    @State private var selectedAnswers: [String?] = []
    @State private var score: Int = 0
    @State private var quizFinished: Bool = false
    @StateObject private var viewModel = AuthViewModel()
    
    private let fullMessage = "Welcome to the Dementia Checker, read the following questions carefully and pick the right answer."
    private let butterColor = Color(red: 1.0, green: 0.85, blue: 0.55) // Butter color definition
    
    var body: some View {
        ZStack {
            // Background Image
            Image("MindfulmeAPP")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .padding(.leading, -50)

            // Overlaying Content
            VStack {
                Spacer()
                
                if isMessageShown && !quizFinished {
                    Text(fullMessage)
                        .foregroundColor(.black)
                        .fontWeight(.heavy)
                        .padding()
                        .background(Color.yellow)
                        .cornerRadius(20)
                }
                
                if !quizFinished {
                    if !questions.isEmpty {
                        VStack {
                            Text(questions[currentQuestionIndex].title)
                                .foregroundColor(.yellow)
                                .fontWeight(.heavy)
                                .padding()
                                .background(Color.black)
                                .cornerRadius(20)
                                .padding(.bottom, 20)
                            
                            VStack(spacing: 5) { // Reduced spacing
                                ForEach(questions[currentQuestionIndex].options, id: \.self) { option in
                                    HStack {
                                        Text(option)
                                            .foregroundColor(.yellow)
                                            .padding(5) // Reduced padding
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .lineLimit(1) // Ensure the text does not overflow

                                        Spacer()
                                        
                                        Button(action: {
                                            selectedAnswers[currentQuestionIndex] = option
                                        }) {
                                            Circle()
                                                .fill(selectedAnswers[currentQuestionIndex] == option ? Color.blue : Color.gray)
                                                .frame(width: 18, height: 18)
                                                .padding(.trailing, 6)
                                        }
                                    }
                                    .padding(5) // Reduced padding
                                    .background(Color.black)
                                    .cornerRadius(8)
                                    .frame(maxWidth: UIScreen.main.bounds.width * 0.9) // Adjust width to fit screen
                                }
                            }
                            .padding(.horizontal, 8)
                            
                            HStack {
                                if currentQuestionIndex > 0 {
                                    Button(action: {
                                        if currentQuestionIndex > 0 {
                                            currentQuestionIndex -= 1
                                        }
                                    }) {
                                        Text("Previous Question")
                                            .foregroundColor(.black)
                                            .fontWeight(.semibold)
                                            .padding(10) // Reduced padding
                                            .background(Color.yellow)
                                            .cornerRadius(10)
                                    }
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    if selectedAnswers[currentQuestionIndex] != nil {
                                        if currentQuestionIndex < questions.count - 1 {
                                            currentQuestionIndex += 1
                                        } else {
                                            calculateScore()
                                            quizFinished = true
                                            isMessageShown = false // Hide the welcome message
                                        }
                                    }
                                }) {
                                    Text(currentQuestionIndex == questions.count - 1 ? "Finish Quiz" : "Next Question")
                                        .foregroundColor(.black)
                                        .fontWeight(.semibold)
                                        .padding(10) // Reduced padding
                                        .background(Color.yellow)
                                        .cornerRadius(10)
                                }
                            }
                            .padding(.top, 20)
                        }
                        .padding()
                    } else {
                        Text("Loading questions...")
                            .foregroundColor(.white)
                    }
                } else {
                    VStack {
                        Text("Quiz Finished!")
                            .foregroundColor(.yellow)
                            .fontWeight(.semibold)
                            .padding(10) // Reduced padding
                            .background(Color.black)
                            .cornerRadius(10)
                        
                        Text("Your Score: \(score)/\(questions.count)")
                            .foregroundColor(.yellow)
                            .fontWeight(.semibold)
                            .padding(10) // Reduced padding
                            .background(Color.black)
                            .cornerRadius(10)
                        
                        Button(action: {
                            restartQuiz()
                        }) {
                            Text("Take Another Quiz")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .padding(10) // Reduced padding
                                .background(Color.yellow)
                                .cornerRadius(10)
                        }
                        .padding(.top, 20) // Add some spacing above the button
                    }
                }
                
                Spacer()
            }
        }
        .onAppear {
            // Fetch random questions
            viewModel.fetchRandomQuestions { fetchedQuestions in
                self.questions = fetchedQuestions
                self.selectedAnswers = Array(repeating: nil, count: fetchedQuestions.count)
            }
        }
    }
    
    private func calculateScore() {
        score = zip(questions, selectedAnswers).filter { $0.answer == $1 }.count
    }
    
    private func restartQuiz() {
        currentQuestionIndex = 0
        score = 0
        quizFinished = false
        isMessageShown = true
        
        // Fetch new set of random questions
        viewModel.fetchRandomQuestions { fetchedQuestions in
            self.questions = fetchedQuestions
            self.selectedAnswers = Array(repeating: nil, count: fetchedQuestions.count)
        }
    }
}

struct DementiaView_Previews: PreviewProvider {
    static var previews: some View {
        DementiaView()
    }
}
