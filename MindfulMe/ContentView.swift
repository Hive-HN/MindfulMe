//
//  ContentView.swift
//  MindfulMe
//
//  Created by Noureldin Abdelaziz on 5/17/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showSignup: Bool = false
    @State private var isKeybaordShowing: Bool = false
    var body: some View {
        NavigationStack{
            Login(showSignup :$showSignup)
                .navigationDestination(isPresented: $showSignup){
                    Signup(showSignup: $showSignup)
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification), perform: { _ in
                    if !showSignup{
                        isKeybaordShowing = true
                    }
                })
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification), perform: { _ in
                    
                        isKeybaordShowing = false
                    
                })
        }
    }
}

#Preview {
    ContentView()
}
