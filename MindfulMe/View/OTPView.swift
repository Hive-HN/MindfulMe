import SwiftUI
struct OTPView: View {
    @Binding var otpText: String
    @State private var navigateToReset = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 15, content: {
                Button(action: {
                    dismiss()
                }, label :{
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.gray)
                })
                .padding(.top, 10)
                
                Text("OTP Verification Code")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .padding(.top, 5)
                
                Text("Please enter the 6 digit code that we sent to your email!")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
                    .padding(.top, -5)
                
                VStack(spacing: 25) {
                    CustomTF(sfIcon: "at", iconTint: .gray, hint: "OTP Code", value: $otpText)
                        .keyboardType(.numberPad)
                        .hSpacing(.trailing)
                    
                    NavigationLink(destination: PasswordResetView(), isActive: $navigateToReset) {
                        GradientButton(title: "Submit Code", icon: "arrow.right") {
                            navigateToReset = true
                        }
                    }
                    .hSpacing(.trailing)
                    .disableWithOpacity(otpText.isEmpty)
                }
                .padding(.top, 20)
            })
            .padding(.vertical, 15)
            .padding(.horizontal, 25)
            .interactiveDismissDisabled()
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
