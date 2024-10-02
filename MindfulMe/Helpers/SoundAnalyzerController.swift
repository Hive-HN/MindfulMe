import Foundation
import AVFoundation
import SoundAnalysis
import SwiftUI

class SoundAnalyzerController: ObservableObject, EmotionClassifierDelegate {
    private let audioEngine = AVAudioEngine()
    private var soundClassifier: EmotionModel
    private var inputFormat: AVAudioFormat!
    private var analyzer: SNAudioStreamAnalyzer!
    private var resultsObserver: ResultsObserver!
    private let analysisQueue = DispatchQueue(label: "com.apple.AnalysisQueue")
    
    @Published var transcriberText: String = ""
    @Published var color: Color = .white
    @Published var isAnalyzing: Bool = false
    
    init(model: EmotionModel) {
        self.soundClassifier = model
        self.resultsObserver = ResultsObserver(delegate: self)
        self.inputFormat = audioEngine.inputNode.inputFormat(forBus: 0)
        self.analyzer = SNAudioStreamAnalyzer(format: inputFormat)
    }
    
    func startAnalyzing() {
        
        isAnalyzing = true
        let request: SNClassifySoundRequest
        do {
            request = try SNClassifySoundRequest(mlModel: soundClassifier.model)
            try analyzer.add(request, withObserver: resultsObserver)
            startAudioEngine()
        } catch {
            print("Unable to prepare request: \(error.localizedDescription)")
            return
            
        }
    }
    
    func stopAnalyzing() {
        isAnalyzing = false
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        analyzer.removeAllRequests()
    }
    
    private func startAudioEngine() {
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 8000, format: inputFormat) { buffer, time in
            self.analysisQueue.async {
                self.analyzer.analyze(buffer, atAudioFramePosition: time.sampleTime)
            }
        }
        
        do {
            try audioEngine.start()
        } catch {
            print("Error starting the Audio Engine: \(error.localizedDescription)")
        }
    }
    
    func displayPredictionResult(identifier: String, confidence: Double) {
        
        DispatchQueue.main.async {
            let roundedConfidence = Double(round(100 * confidence) / 100)
            if roundedConfidence > 60 {
                switch identifier {
                case "happy":
                    self.color = Color("Yellow.happy")
                case "sad":
                    self.color = .blue
                case "surprise":
                    self.color = .yellow
                case "angry":
                    self.color = .red
                case "disgust":
                    self.color = .green
                case "neutral":
                    self.color = .white
                case "fear":
                    self.color = .black
                default:
                    self.color = .white
                }
                
                self.transcriberText = ("Recognition: \(identifier) with Confidence \(roundedConfidence)")
            } else {
                self.transcriberText = ("Speak louder")
            }
        }
    }
    
    func analyzeAudioFile(url: URL) {
        // Ensure that the audio file can be created from the URL
        guard let audioFile = try? AVAudioFile(forReading: url) else {
            print("Error: Unable to create AVAudioFile from URL")
            return
        }
        
        // Create an audio buffer
        let format = audioFile.processingFormat
        let frameCount = UInt32(audioFile.length)
        let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount)!
        do {
            try audioFile.read(into: buffer)
        } catch {
            print("Error reading audio file into buffer: \(error.localizedDescription)")
            return
        }
        
        let request: SNClassifySoundRequest
        do {
            request = try SNClassifySoundRequest(mlModel: soundClassifier.model)
            let resultsObserver = ResultsObserver(delegate: self)
            try analyzer.add(request, withObserver: resultsObserver)
            
            // Analyze the buffer
            self.analysisQueue.async {
                self.analyzer.analyze(buffer, atAudioFramePosition: 0)
            }
        } catch {
            print("Error analyzing audio file: \(error.localizedDescription)")
        }
    }
}

class ResultsObserver: NSObject, SNResultsObserving {
    weak var delegate: EmotionClassifierDelegate?
    
    init(delegate: EmotionClassifierDelegate) {
        self.delegate = delegate
    }
    
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let result = result as? SNClassificationResult,
              let classification = result.classifications.first else { return }
        
        let confidence = classification.confidence * 100.0
        
        if confidence > 60 {
            delegate?.displayPredictionResult(identifier: classification.identifier, confidence: confidence)
        }
    }
}

protocol EmotionClassifierDelegate: AnyObject {
    func displayPredictionResult(identifier: String, confidence: Double)
}
