import FirebaseFirestore
import Firebase

import Foundation

struct Question: Codable {
    let title: String
    let answer: String
    let options: [String]
}
func uploadQuestions() {
    let questions: [Question] = [
        Question(title: "What day comes after Wednesday?", answer: "Thursday", options: ["Sunday", "Tuesday", "Friday", "Thursday"]),
        Question(title: "What is 3 + 4?", answer: "7", options: ["8", "10", "7", "6"]),
        Question(title: "Which of these animals can fly?", answer: "Bird", options: ["Bird", "Dog", "Cat", "Fish"]),
        Question(title: "What is the color of the sky on a clear day?", answer: "Blue", options: ["Red", "Blue", "Green", "Yellow"]),
        Question(title: "Choose an item you might find in a kitchen", answer: "Refrigerator", options: ["Telephone", "Couch", "Desk", "Refrigerator"]),
        Question(title: "Which season comes in September?", answer: "Fall", options: ["Winter", "Spring", "Summer", "Fall"]),
        Question(title: "What is the next number in the sequence: 2, 4, 6, 8, _?", answer: "10", options: ["11", "10", "12", "14"]),
        Question(title: "Which of these is a common breakfast cereal?", answer: "Oatmeal", options: ["Spaghetti", "Chicken", "Oatmeal", "Pizza"]),
        Question(title: "Which holiday is celebrated on December 25th?", answer: "Christmas", options: ["Thanksgiving", "Halloween", "Easter", "Christmas"]),
        Question(title: "What is the primary color of the sun?", answer: "Yellow", options: ["Yellow", "Red", "Blue", "Green"]),
        Question(title: "Which month comes after April?", answer: "May", options: ["March", "May", "June", "February"]),
        Question(title: "Which emotion is often associated with feeling happy and content?", answer: "Joy", options: ["Anger", "Sadness", "Joy", "Fear"]),
        Question(title: "Which of the following is a fruit?", answer: "Apple", options: ["Carrot", "Broccoli", "Apple", "Potato"]),
        Question(title: "What do you use to write on paper?", answer: "Pen", options: ["Eraser", "Pen", "Ruler", "Glue"]),
        Question(title: "Which of these shapes has four sides?", answer: "Square", options: ["Circle", "Triangle", "Square", "Oval"]),
        Question(title: "Which item is used to tell the time?", answer: "Watch", options: ["Telephone", "Calendar", "Watch", "Book"]),
        Question(title: "Which of these is a type of weather?", answer: "Sunshine", options: ["Sunshine", "Chair", "Computer", "Car"]),
        Question(title: "What is the capital of the United States?", answer: "Washington, D.C.", options: ["New York", "Washington, D.C.", "Los Angeles", "Chicago"]),
        Question(title: "Which of these is used for eating soup?", answer: "Spoon", options: ["Fork", "Knife", "Spoon", "Plate"]),
        Question(title: "What do you call the device used to make a call?", answer: "Telephone", options: ["Television", "Computer", "Spoon", "Radio"])
    ]
    
    let db = Firestore.firestore()
    
    for question in questions {
        do {
            try db.collection("questions").addDocument(from: question)
            print("Uploaded question: \(question.title)")
        } catch let error {
            print("Error uploading question: \(error.localizedDescription)")
        }
    }
}
