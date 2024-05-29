import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Image
                Image("MindfulmeAPP")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .padding(.leading, -50)
                
                VStack {
                    Spacer()
                    
                    HStack(spacing: 20) {
                        NavigationLink(destination: VoiceRecognitionView()) {
                            Text("Check your Mood")
                                .foregroundColor(.black)
                                .fontWeight(.heavy)
                                .padding()
                                .background(Color.yellow)
                                .cornerRadius(10)
                        }
                        
                        NavigationLink(destination: DementiaView()) {
                            Text("Dementia Checker")
                                .foregroundColor(.black)
                                .fontWeight(.heavy)
                                .padding()
                                .background(Color.yellow)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    
                    HStack {
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape")
                                .foregroundColor(.white)
                                .padding()
                                .font(.system(size: 20, weight: .bold))
                        }
                        Spacer()
                        Button(action: {
                            // Current page, no action needed
                        }) {
                            Image(systemName: "house.fill")
                                .foregroundColor(.white)
                                .padding()
                                .font(.system(size: 20, weight: .bold))
                        }
                        Spacer()
                        NavigationLink(destination: MyAccountView()) {
                            Image(systemName: "person")
                                .foregroundColor(.white)
                                .padding()
                                .font(.system(size: 20, weight: .bold))
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.5))
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AuthViewModel())
    }
}
