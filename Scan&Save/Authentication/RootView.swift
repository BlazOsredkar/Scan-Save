//
//  RootView.swift
//  Scan&Save
//
//  Created by Blaž Osredkar on 28. 10. 23.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                MenuBarView(showSignInView: $showSignInView)
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView, content: {
            NavigationStack{
                LoginView()
            }
        })
    }
}

#Preview {
    RootView()
}
