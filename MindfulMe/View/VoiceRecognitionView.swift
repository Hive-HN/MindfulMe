import SwiftUI
import AVFoundation

struct VoiceRecognitionView: View {
    @State private var currentPage = "record"
    @State private var recordings: [URL] = []

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                Image("MindfulmeAPP")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .offset(x: -30)

                VStack {
                    
                    if currentPage == "record" {
                        RecordView(recordings: $recordings)
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.95) // Adjust the height as needed
                    } else if currentPage == "records" {
                        RecordsView(recordings: recordings, onDelete: { index in
                            recordings.remove(at: index)
                        })
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.95)

                    }

                    Spacer()

                    HStack {
                        Spacer()

                        Button(action: {
                            currentPage = "record"
                        }) {
                            HStack {
                                Image(systemName: "mic.fill")
                                Text("Record")
                            }
                            .padding()
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                        }

                        Spacer()

                        Button(action: {
                            currentPage = "records"
                        }) {
                            HStack {
                                Image(systemName: "waveform.path.ecg")
                                Text("My Records")
                            }
                            .padding()
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                        }

                        Spacer()
                    }
                    .padding()
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct RecordView: View {
    @Binding var recordings: [URL]
    @State private var audioRecorder: AVAudioRecorder?
    @State private var isRecording = false

    var body: some View {
        
        VStack {
            Button(action: {
                if isRecording {
                    // Stop Recording
                    isRecording = false
                    audioRecorder?.stop()
                    if let audioURL = audioRecorder?.url {
                        recordings.append(audioURL) // Save the recorded audio to recordings
                    }
                } else {
                    // Start Recording
                    isRecording = true
                    // Start audio recording
                    let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
                    let settings = [
                        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                        AVSampleRateKey: 12000,
                        AVNumberOfChannelsKey: 1,
                        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                    ]
                    do {
                        audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                        audioRecorder?.record()
                    } catch {
                        // Handle recording error
                        print("Error recording audio: \(error.localizedDescription)")
                    }
                }
            }) {
                Text(isRecording ? "Stop Recording": "Start Recording")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.black)
            }
                .padding()
               .background(Color.yellow)
               .cornerRadius(25)

            if isRecording {
                WaveformView()
            }
        }
    }
}

struct WaveformView: View {
    var body: some View {
        Rectangle()
            .fill(Color.black)
            .frame(height: 50)
            .cornerRadius(5)
            .padding()
    }
}

struct RecordsView: View {
    var recordings: [URL]
    var onDelete: (Int) -> Void
    
    var body: some View {
        VStack {
            if (recordings.count == 0) {
                Text("The File Is Empty...")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.black)
                    .background(Color.yellow)
            }
            else {
                List {
                    ForEach(recordings.indices, id: \.self) { index in
                        HStack {
                            Text(recordings[index].lastPathComponent)
                            Spacer()
                            Button(action: {
                                onDelete(index)
                            }) {
                                Image(systemName: "trash")
                            }
                        }
                    }
                }
            }
        }
    }
}

func getDocumentsDirectory() -> URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}

struct VoiceRecognitionView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceRecognitionView()
    }
}
