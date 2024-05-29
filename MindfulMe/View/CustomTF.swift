//
//  CustomTF.swift
//  MindfulMe
//
//  Created by Noureldin Abdelaziz on 5/17/24.
//

import SwiftUI

struct CustomTF: View {
    var sfIcon : String
    var iconTint : Color
    var hint: String
    var isPassword: Bool = false
    @Binding var value : String
    @State private var showPassword = false
    var body: some View {
        HStack(alignment: .top , spacing: 8, content: {
            Image(systemName: sfIcon)
                .foregroundColor(.white)
                .frame(width: 30)
                .offset(y: 15)
            VStack(alignment: .leading , spacing: 8,content: {
                if isPassword{
                    Group{
                        if showPassword{
                            TextField(hint, text: $value)
                                .padding(.vertical, 15) // Increase vertical padding
                                   .padding(.horizontal, 10) // Maintain horizontal padding
                                   .frame(height: 50) // Set the height to 50 points
                                   .background(Color.white)
                                   .cornerRadius(8)
                                   .shadow(radius: 1)


                        }else {
                            SecureField(hint, text: $value)
                                .padding(.vertical, 15) // Increase vertical padding
                                   .padding(.horizontal, 10) // Maintain horizontal padding
                                   .frame(height: 50) // Set the height to 50 points
                                   .background(Color.white)
                                   .cornerRadius(8)
                                   .shadow(radius: 1)

                        }
                    }
                }else {
                    TextField(hint, text: $value)
                        .padding(.vertical, 15) // Increase vertical padding
                           .padding(.horizontal, 10) // Maintain horizontal padding
                           .frame(height: 50) // Set the height to 50 points
                           .background(Color.white)
                           .cornerRadius(8)
                           .shadow(radius: 1)

                }
                Divider()
            })
            .overlay(alignment: .trailing){
                if isPassword{
                    Button(action: {
                        withAnimation{
                            showPassword.toggle()
                        }
                    }, label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundStyle(.gray)
                            .padding(10)
                            .contentShape(.rect)
                    })
                }
            }
        })
    }
}
