//
//  ContentView.swift
//  MindfulMe
//
//  Created by Noureldin Abdelaziz on 5/17/24.
//


import SwiftUI

struct Signup: View {
    @Binding var showSignup: Bool
    @State private var emailID: String = ""
    @State private var FullName: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
 
    @State private var askOTP: Bool = false
    @State private var otpText: String = ""
    @State private var passwordError: String? = nil
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        ZStack {
            // Background Image
            Image("MindfulmeAPP")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .padding(.leading, -30)

            // Main content
            VStack(alignment: .leading, spacing: 15, content: {
                HStack {
                        Button(action: {
                        showSignup = false
                    }) {
                Image(systemName: "arrow.left")
                .font(.title2)
                .foregroundColor(.white)
                .padding()
                }
            Spacer()
                }
            .padding(.top, -5) // Adjust top padding as needed
            .padding(.leading, -20) // Adjust leading padding as needed
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                VStack(spacing: 25){
                    CustomTF(sfIcon: "person", iconTint: .gray, hint: "Full Name", value: $FullName)
                    CustomTF(sfIcon: "at", iconTint: .gray, hint: "Email", value: $emailID)
                    CustomTF(sfIcon: "lock", iconTint: .gray, hint: "Password", isPassword: true, value: $password)
                        .padding(.top, 5)
                    if let error = passwordError {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    CustomTF(sfIcon: "lock", iconTint: .gray, hint: "Confirm Password", isPassword: true, value: $confirmPassword)
                        .padding(.top, 5)
                    if let error = passwordError {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                   
                   
                    GradientButton(title: "Signup", icon: "arrow.right") {
                        Task {
                            try await viewModel.createUser(withEmail:emailID, password:password, fullname:FullName)

                        }
                    }
                    .hSpacing(.trailing)
                    .disableWithOpacity(!formIsValid)
                }
                .padding(.top, 20)

                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)

                HStack(spacing: 6) {
                    Text("Already Have Account ? ")
                        .foregroundStyle(.white)
                    Button("Login") {
                        showSignup = false
                    }
                    .foregroundStyle(.yellow)

                    .fontWeight(.bold)
                }
                .font(.callout)
                .hSpacing()
            })
            .padding(.vertical, 15)
            .padding(.horizontal, 25)
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $askOTP, content: {
            if #available(iOS 17, *){
                OTPView(otpText : $otpText)
                    .presentationDetents([.height(350)])
                    .presentationCornerRadius(30)
            }
            else{
                OTPView(otpText : $otpText)
                    .presentationDetents([.height(350)])
            }
        })
    }
}
extension Signup : AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !emailID.isEmpty
        && emailID.contains("@")
        && password.count>8
        && !password.isEmpty
        && confirmPassword == password
        && !FullName.isEmpty
        
          && password.count >= 6
      }
}

#Preview {
    ContentView()
}
