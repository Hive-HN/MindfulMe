//
//  ContentView.swift
//  MindfulMe
//
//  Created by Noureldin Abdelaziz on 5/17/24.
//


import SwiftUI

struct Login: View {
    @Binding var showSignup: Bool
    @State private var emailID: String = ""
    @State private var password: String = ""
    @State private var showForgotPassword: Bool = false
    @State private var showResetView: Bool = false

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
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                
                VStack(spacing: 25){
                    CustomTF(sfIcon: "at", iconTint: .gray, hint: "Email", value: $emailID)
                    CustomTF(sfIcon: "lock", iconTint: .gray, hint: "Password", isPassword: true, value: $password)
                        .padding(.top, 5)
                   
                    GradientButton(title: "Login", icon: "arrow.right") {
                    }
                    .hSpacing(.trailing)
                    .disableWithOpacity(emailID.isEmpty || password.isEmpty)
                    Button("Forgot Password?") {
                        showForgotPassword.toggle()
                    }
                    .foregroundStyle(.yellow)
                    .font(.callout)
                    .fontWeight(.heavy)
                    .hSpacing(.trailing)
                }
                .padding(.top, 20)

                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)

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
                
            }else {
                ForgotPassword(showResetView: $showResetView)
                    .presentationDetents([.height(300)])

            }
        })
        .sheet(isPresented: $showResetView, content: {
            if #available(iOS 17, *){
                PasswordResetView()
                    .presentationDetents([.height(300)])
                    .presentationCornerRadius(30)
                
            }else {
                PasswordResetView()
                    .presentationDetents([.height(300)])

            }
        })
    }
}

#Preview {
    ContentView()
}
