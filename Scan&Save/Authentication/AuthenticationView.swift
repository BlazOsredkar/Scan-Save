//
//  AuthenticationView.swift
//  Scan&Save
//
//  Created by Blaž Osredkar on 27. 10. 23.
//

import SwiftUI

struct AuthenticationView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        VStack{
            
            NavigationLink {
                SignInEmailView()
            } label: {
                Text("Sign up with Email")
            }
            
        }
        .navigationTitle("Sign in")
    }
}

#Preview {
    NavigationStack{
        AuthenticationView()
    }
}
