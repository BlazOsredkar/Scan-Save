//
//  LoginView.swift
//  Scan&Save
//
//  Created by Blaž Osredkar on 28. 10. 23.
//

import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var error_text: String = ""
    
    @Published var shouldNavigateToHome = false
    @Published var showErrorAlert = false
    
    
    func signIn(){
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            error_text = "Please fill in all fields to continue."
            showErrorAlert = true
            return
        }
        
        Task {
            do  {
                
                let retunedUserData = try await AuthenticationManager.shared.signIN(email: email, password: password)
                print("Sucess")
                print(retunedUserData)
                
                shouldNavigateToHome = true
                
            } catch {
                print("Error \(error)")
            }
        }
    }
    
}

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
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
                    
                   
                    Button {
                        viewModel.signIn()
                    } label: {
                        HStack {
                            Image(systemName: "key.horizontal.fill")
                            Text("Login")
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
                        SignInEmailView()
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
    LoginView()
}
