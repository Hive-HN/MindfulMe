import SwiftUI
import FirebaseAuth
import Firebase

struct Login: View {
    @Binding var showSignup: Bool
    @State private var emailID: String = ""
    @State private var password: String = ""
    @State private var showForgotPassword: Bool = false
    @State private var showResetView: Bool = false
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var emailError: String? = nil
    @State private var passwordError: String? = nil

    var body: some View {
        ZStack {
            // Background Image
            Image("MindfulmeAPP")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .padding(.leading, -50)
            
            // Main content
            VStack(alignment: .leading, spacing: 15, content: {
                Spacer(minLength: 0)
                
                VStack(spacing: 25){
                    CustomTF(sfIcon: "at", iconTint: .gray, hint: "Email", value: $emailID)
                    if let error = emailError {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    CustomTF(sfIcon: "lock", iconTint: .gray, hint: "Password", isPassword: true, value: $password)
                        .padding(.top, 5)
                    if let error = passwordError {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                   
                    GradientButton(title: "Login", icon: "arrow.right") {
                        validateAndLogin()
                    }
                    .hSpacing(.trailing)
                    .disableWithOpacity(!formIsValid)
                    
                    Button("Forgot Password?") {
                        showForgotPassword.toggle()
                    }
                    .foregroundStyle(.yellow)
                    .font(.callout)
                    .fontWeight(.heavy)
                    .hSpacing(.trailing)
                }
                .padding(.top, 20)
                
                Spacer(minLength: 0)
                
                HStack(spacing: 6) {
                    Text("Don't have an account?")
                        .foregroundStyle(.white)
                    Button("Sign Up") {
                        showSignup.toggle()
                    }
                    .fontWeight(.bold)
                    .foregroundStyle(.yellow)
                }
                .font(.callout)
                .hSpacing()
            })
            .padding(.vertical, 15)
            .padding(.horizontal, 25)
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showForgotPassword, content: {
            if #available(iOS 17, *){
                ForgotPassword(showResetView: $showResetView)
                    .presentationDetents([.height(300)])
                    .presentationCornerRadius(30)
            } else {
                ForgotPassword(showResetView: $showResetView)
                    .presentationDetents([.height(300)])
            }
        })
        .sheet(isPresented: $showResetView, content: {
            if #available(iOS 17, *){
                PasswordResetView()
                    .presentationDetents([.height(300)])
                    .presentationCornerRadius(30)
            } else {
                PasswordResetView()
                    .presentationDetents([.height(300)])
            }
        })
    }
    
    private func validateAndLogin() {
        // Reset error messages
        emailError = nil
        passwordError = nil
        
        // Validate email
        if !isValidEmail(emailID) {
            emailError = "Email is not valid"
            return
        }
        
        // Validate password
        if password.count < 6 {
            passwordError = "Password must be at least 6 characters"
            return
        }
        
        Task {
            do {
                try await viewModel.signIn(withEmail: emailID, password: password)
            } catch {
                // Handle sign-in error on the main thread
                DispatchQueue.main.async {
                    passwordError = "Invalid email or password"
                }
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

extension Login : AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !emailID.isEmpty
       && isValidEmail(emailID)
        && !password.isEmpty
          && password.count >= 6
      }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(showSignup: .constant(false))
          ContentView()
        .environmentObject(AuthViewModel())

    }
}
