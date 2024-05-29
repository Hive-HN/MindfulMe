import SwiftUI

struct DementiaView: View {
    @State private var displayedText: String = ""
    @State private var isTextVisible: Bool = false
    @State private var isMessageShown: Bool = false
    private let fullMessage = "Welcome to the Dementia Checker, we are here always to help you have a better and healthier life. Please listen to the following questions and answer using our voice recorder."

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
                
                if isTextVisible && isMessageShown {
                    Text(displayedText)
                        .font(.system(size: 24, weight: .bold)) // Custom font size and weight
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                        .padding()
                        .transition(.opacity) // Fade in effect
                }
                
                Spacer()
            }
        }
        .onAppear {
            // Delay the appearance of the text
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                isTextVisible = true
                isMessageShown = true
                typeWriterEffect()
                
                // Hide the message after 10 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    withAnimation {
                        isMessageShown = false
                    }
                }
            }
        }
    }
    
    private func typeWriterEffect() {
        let words = fullMessage.split(separator: " ").map(String.init)
        var wordIndex = 0
        var characterIndex = 0
        
        // Function to update the displayed text
        func updateText() {
            if wordIndex < words.count {
                if characterIndex < words[wordIndex].count {
                    displayedText += String(words[wordIndex][words[wordIndex].index(words[wordIndex].startIndex, offsetBy: characterIndex)])
                    characterIndex += 1
                } else {
                    displayedText += " "
                    characterIndex = 0
                    wordIndex += 1
                }
                
                // Schedule the next character update
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    updateText()
                }
            }
        }
        
        // Start the typing effect
        updateText()
    }
}

struct DementiaView_Previews: PreviewProvider {
    static var previews: some View {
        DementiaView()
    }
}
