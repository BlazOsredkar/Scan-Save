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
    
    @Published var shouldNavigateToHome = false
    
    
    func signIn(){
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
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
                    TextField("", text: $viewModel.email, prompt: Text("Email...").foregroundColor(.white))
                        .padding()
                        .background(Color(red: 0.37, green: 0.47, blue: 1.00))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 1)
                        )
                                                
                    SecureField("Password...", text: $viewModel.password)
                        .padding()
                        .background(Color(red: 0.37, green: 0.47, blue: 1.00))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    SecureField("Repeat password...", text: $viewModel.confirm_password)
                        .padding()
                        .background(Color(red: 0.37, green: 0.47, blue: 1.00))
                        .cornerRadius(10)
                    
                    
                    
                    Button {
                        viewModel.signIn()
                    } label: {
                        Text("Sign in")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    Spacer()
                    
                }
                .padding()
                .cornerRadius(15)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // Center content in VStack
                Spacer()

                ZStack {
                    
                }.fullScreenCover(isPresented: $viewModel.shouldNavigateToHome, content: {
                    NavigationStack{
                        MenuBarView(showSignInView: .constant(false))
                    }
                })
            }
        }
    }
}

#Preview {
    NavigationStack{
        SignInEmailView()
    }
}
