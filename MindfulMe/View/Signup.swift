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
    @State private var FirstName: String = ""
    @State private var LastName: String = ""

    @State private var askOTP: Bool = false
    @State private var otpText: String = ""
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
                    CustomTF(sfIcon: "person", iconTint: .gray, hint: "First Name", value: $FirstName)
                    CustomTF(sfIcon: "person", iconTint: .gray, hint: "Last Name", value: $LastName)
                    CustomTF(sfIcon: "at", iconTint: .gray, hint: "Email", value: $emailID)
                   
                   
                    GradientButton(title: "Signup", icon: "arrow.right") {
                        askOTP.toggle()
                    }
                    .hSpacing(.trailing)
                    .disableWithOpacity(emailID.isEmpty)
                }
                .padding(.top, 20)

                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)

                HStack(spacing: 6) {
                    Text("Already Have Account ? ")
                        .foregroundStyle(.white)
                    Button("Login") {
                        showSignup = false
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

#Preview {
    ContentView()
}
