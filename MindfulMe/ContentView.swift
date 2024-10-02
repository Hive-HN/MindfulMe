import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = AuthViewModel()
    @State private var showSignup: Bool = false
    @State private var isKeyboardShowing: Bool = false

    var body: some View {
        NavigationStack {
            if viewModel.userSession != nil {
                HomeView() // Start with HomeView
            } else {
                Login(showSignup: $showSignup)
                    .navigationDestination(isPresented: $showSignup) {
                        Signup(showSignup: $showSignup)
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification), perform: { _ in
                        if !showSignup {
                            isKeyboardShowing = true
                        }
                    })
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification), perform: { _ in
                        isKeyboardShowing = false
                    })
            }
        }
        .environmentObject(viewModel)
        .onChange(of: viewModel.userSession) { newValue in
            if newValue != nil {
                // Optional: Additional logic when userSession changes
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
