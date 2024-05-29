//
//  ContentView.swift
//  MindfulMe
//
//  Created by Noureldin Abdelaziz on 5/17/24.
//


import SwiftUI

struct PasswordResetView: View {
    @State private var Password: String = ""
    @State private var confirmPassword: String = ""

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        
    VStack(alignment: .leading, spacing: 15, content: {
            
        Button(action: {
            dismiss()
        }, label :{
                Image(systemName: "xmark")
                .font(.title2)
                .foregroundColor(.gray)
                })
        .padding(.top, 50)
        
        Text("Reset Password?")
            .font(.largeTitle)
            .fontWeight(.heavy)
            .padding(.top, 5)

        
        VStack(spacing: 10){
            CustomTF(sfIcon: "lock", iconTint: .gray, hint: "Password", isPassword: true, value: $Password)
               
            CustomTF(sfIcon: "lock", iconTint: .gray, hint: "Confirm Password", isPassword: true, value: $confirmPassword)
                .padding(.top, 5)
                    .hSpacing(.trailing)
                    GradientButton(title: "Send Link", icon: "arrow.right") {
                  
                    }
                    .hSpacing(.trailing)
                    .disableWithOpacity(Password.isEmpty || confirmPassword.isEmpty)
                }
                .padding(.top, 5)
            })
            .padding(.vertical, 15)
            .padding(.horizontal, 25)
            .interactiveDismissDisabled()
    }
}

#Preview {
    ContentView()
}
