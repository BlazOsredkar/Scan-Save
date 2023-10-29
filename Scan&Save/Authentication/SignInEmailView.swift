//
//  SignInEmailView.swift
//  Scan&Save
//
//  Created by Blaž Osredkar on 27. 10. 23.
//

import SwiftUI

@MainActor
final class SignInEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var confirm_password = ""
    @Published var error_text: String = ""
    
    @Published var shouldNavigateToHome = false
    @Published var showErrorAlert = false
    
    
    func signIn(){
        guard !email.isEmpty, !password.isEmpty, !confirm_password.isEmpty else {
            print("No email or password found")
            error_text = "Please fill in all fields to continue."
            showErrorAlert = true
            return
        }
        
        Task {
            do  {
                if password == confirm_password {
                    let retunedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
                    print("Sucess")
                    print(retunedUserData)
                    
                    shouldNavigateToHome = true
                } else {
                    print("Can save user, wrong password confirm")
                    error_text = "Passwords do not match."
                    showErrorAlert = true
                }
                
            } catch {
                print("Error \(error)")
            }
        }
    }
    
}

struct SignInEmailView: View {
    
    @StateObject private var viewModel = SignInEmailViewModel()
    
    var body: some View {
        ZStack {
            Color(red: 0.22, green: 0.34, blue: 0.96)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Scan&Save")
                    .padding(.top, 70)
                    .foregroundColor(.white)
                    .font(.system(size: 36))
                    
                VStack(alignment: .center, spacing: 10)
                {
                    Text("E-mail:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.white)
                    TextField("", text: $viewModel.email, prompt: Text("Email...").foregroundColor(.white))
                        .padding()
                        .background(Color(red: 0.37, green: 0.47, blue: 1.00))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 0.5)
                        )
                    
                    Spacer()
                        .frame(height: 5)
                         
                    Text("Password:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.white)
                    SecureField("", text: $viewModel.password, prompt: Text("Password...").foregroundColor(.white))
                        .padding()
                        .background(Color(red: 0.37, green: 0.47, blue: 1.00))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 0.5)
                        )
                    Spacer()
                        .frame(height: 5)
                    
                    Text("Repeat password:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.white)
                    SecureField("", text: $viewModel.confirm_password, prompt: Text("Repeat password...").foregroundColor(.white))
                        .padding()
                        .background(Color(red: 0.37, green: 0.47, blue: 1.00))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 0.5)
                        )
                    
                    Spacer()
                        .frame(height: 5)
                    Button {
                        viewModel.signIn()
                    } label: {
                        HStack {
                            Image(systemName: "key.horizontal.fill")
                            Text("Sign up")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                    }
                    Spacer()
                        .frame(height: 5)
                    NavigationLink {
                        AuthenticationView()
                    } label: {
                        Text("Sign in")
                            .font(.headline)
                            .foregroundColor(.white)
                            .underline()
                    }
                    Spacer()
                    
                }
                .padding()
                .cornerRadius(15)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Center content in VStack
                Spacer()

                ZStack {
                    
                }.fullScreenCover(isPresented: $viewModel.shouldNavigateToHome, content: {
                    NavigationStack{
                        MenuBarView(showSignInView: .constant(false))
                    }
                })
            }
        }.alert(isPresented: $viewModel.showErrorAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.error_text),
                dismissButton: .default(Text("OK")) {
                    // Handle OK button tap if needed
                }
            )
        }
    }
}

#Preview {
    NavigationStack{
        SignInEmailView()
    }
}
