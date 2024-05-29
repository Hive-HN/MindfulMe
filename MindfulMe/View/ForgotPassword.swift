//
//  ContentView.swift
//  MindfulMe
//
//  Created by Noureldin Abdelaziz on 5/17/24.
//


import SwiftUI

struct ForgotPassword: View {
    @Binding var showResetView: Bool
    @State private var emailID: String = ""
    @Environment(\.dismiss) private var dismiss
    @State private var askOTP: Bool = false
    @State private var otpText: String = ""

    var body: some View {
        
    VStack(alignment: .leading, spacing: 15, content: {
            
        Button(action: {
            dismiss()
        }, label :{
                Image(systemName: "arrow.left")
                .font(.title2)
                .foregroundColor(.gray)
                })
        .padding(.top, 10)
        
        Text("Forgot Password?")
            .font(.largeTitle)
            .fontWeight(.heavy)
            .padding(.top, 5)
        
        Text("Please enter your Email so that we can send a code?")
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(.gray)
            .padding(.top, -5)
        
        VStack(spacing: 25){
                CustomTF(sfIcon: "at", iconTint: .gray, hint: "Email", value: $emailID)
                   
                    .hSpacing(.trailing)
                    GradientButton(title: "Send Link", icon: "arrow.right") {
                        askOTP.toggle()

                    }
                    .hSpacing(.trailing)
                    .disableWithOpacity(emailID.isEmpty)
                }
                .padding(.top, 20)
            })
            .padding(.vertical, 15)
            .padding(.horizontal, 25)
            .interactiveDismissDisabled()
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
