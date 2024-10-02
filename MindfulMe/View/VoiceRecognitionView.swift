import SwiftUI
import AVFoundation

struct VoiceRecognitionView: View {
    @StateObject private var mic = MicrophoneMonitor(numberOfSamples: 10)
    @StateObject private var soundAnalyzer = SoundAnalyzerController(model: EmotionModel())
    @State private var isRecording = false
    @State private var recordedAudioURLs: [URL] = []
    @State private var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Image("MindfulmeAPP")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .padding(.leading, -50)

                    VStack {
                        Text("Voice Emotion Detection")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                        
                        // Visual representation of sound levels
                        HStack(spacing: 4) {
                            ForEach(mic.soundSamples, id: \.self) { level in
                                BarView(value: self.normalizeSoundLevel(level: level))
                            }
                            
                        }
                        .frame(height: 150)
                        .padding()
                        
                        // Start/Stop Recording Button
                        Button(action: {
                            isRecording ? stopRecording() : startRecording()
                        }) {
                            Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .foregroundColor(isRecording ? .red : .green)
                        }
                        .padding()
                        
                        // List of recorded audio notes
                        List {
                            ForEach(recordedAudioURLs, id: \.self) { url in
                                HStack {
                                    Button(action: {
                                        playAudio(url: url)
                                    }) {
                                        Image(systemName: "play.circle.fill")
                                            .foregroundColor(.blue)
                                    }
                                    
                                    Button(action: {
                                        analyzeAudioFile(url: url)
                                    }) {
                                        Image(systemName: "waveform")
                                            .foregroundColor(.orange)
                                    }
                                    
                                    Text(url.lastPathComponent)
                                }
                            }
                        }
                        .padding()
                        
                        Spacer()
                        
                        Text(soundAnalyzer.transcriberText)
                            .foregroundColor(soundAnalyzer.color)
                            .padding()
                            .font(.headline)
                    }
                }
            }
        }
    }
    
    // Normalize the sound level for UI representation
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 50) / 2
        return CGFloat(level * (200 / 25)) // scaled to max at 300 (our height of our bar)
    }
    
    private func startRecording() {
        soundAnalyzer.startAnalyzing()
        isRecording = true
        // Implement recording start logic if needed
    }
    
    private func stopRecording() {
        soundAnalyzer.stopAnalyzing()
        isRecording = false
        saveRecording()
    }
    
    private func saveRecording() {
        // Implement the logic to save the recording to a file
        // You should add the file URL to the `recordedAudioURLs` array
    }
    
    private func playAudio(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing audio file: \(error.localizedDescription)")
        }
    }
    
    private func analyzeAudioFile(url: URL) {
        soundAnalyzer.analyzeAudioFile(url: url)
    }
}

struct VoiceRecognitionView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceRecognitionView()
    }
}

struct BarView: View {
    var value: CGFloat

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(LinearGradient(gradient: Gradient(colors: [.purple, .blue]),
                                 startPoint: .top,
                                 endPoint: .bottom))
            .frame(width: 20, height: value)
    }
}
