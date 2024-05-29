//
//  GradientButton.swift
//  MindfulMe
//
//  Created by Noureldin Abdelaziz on 5/17/24.
//

import SwiftUI

struct GradientButton: View {
    var title: String
    var icon: String
    var onClick: () -> ()
    var body: some View {
        Button(action: onClick, label: {
            HStack(spacing: 15){
                Text(title)
                Image(systemName: icon)
            }
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 35)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 173 / 255, green: 216 / 255, blue: 230 / 255), Color.yellow]),
                    startPoint: .top,
                    endPoint: .bottom), in: .capsule
            )

        })
    }
}


