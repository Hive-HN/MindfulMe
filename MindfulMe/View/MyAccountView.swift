import SwiftUI

struct MyAccountView: View {
    @EnvironmentObject var viewModel: AuthViewModel
  
    var body: some View {
        if let user = viewModel.currentUser {
            VStack {
                // Profile Picture
                Text(user.initials)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 72, height: 72)
                    .background(Color(.systemGray3))
                    .clipShape(Circle())
                
                // User Information
                List {
                    Section(header: Text("Profile")) {
                        HStack {
                            Text("Name:")
                                .fontWeight(.bold)
                            Spacer()
                            Text(user.fullname)
                        }
                        HStack {
                            Text("Email:")
                                .fontWeight(.bold)
                            Spacer()
                            Text(user.email)
                        }
                        
                        HStack {
                            Text("ID:")
                                .fontWeight(.bold)
                            Spacer()
                            Text(user.id)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                
                // Log Out Button
                Button(action: {
                    viewModel.signOut()
                }) {
                    Text("Log Out")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.bottom, 20)
            }
            .padding()
            .navigationTitle("My Account")
        }
    }
}

struct MyAccountView_Previews: PreviewProvider {
    static var previews: some View {
        MyAccountView()
            .environmentObject(AuthViewModel())
    }
}
