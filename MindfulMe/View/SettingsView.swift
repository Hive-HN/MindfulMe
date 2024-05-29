import SwiftUI

struct SettingsView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isDarkMode: Bool = false
    @State private var profileImage: Image? = Image(systemName: "person.crop.circle")

    var body: some View {
        Form {
            Section(header: Text("Profile Picture")) {
                HStack {
                    Spacer()
                    profileImage?
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)
                    Spacer()
                }
                Button(action: {
                    // Action to change profile picture
                    // Implement the image picker here
                }) {
                    Text("Change Profile Picture")
                }
            }

            Section(header: Text("Username")) {
                TextField("Enter new username", text: $username)
                Button(action: {
                    // Action to change username
                }) {
                    Text("Change Username")
                }
            }

            Section(header: Text("Password")) {
                SecureField("Enter new password", text: $password)
                Button(action: {
                    // Action to change password
                }) {
                    Text("Change Password")
                }
            }

            Section(header: Text("Appearance")) {
                Toggle(isOn: $isDarkMode) {
                    Text("Dark Mode")
                }
                .onChange(of: isDarkMode) { value in
                    // Action to toggle between dark and light mode
                    if value {
                        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
                    } else {
                        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
                    }
                }
            }
        }
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
