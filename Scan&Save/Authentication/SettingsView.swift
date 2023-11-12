//
//  SettingsView.swift
//  Scan&Save
//
//  Created by Blaž Osredkar on 28. 10. 23.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    
    
    func logOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
}

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    var body: some View {
        List {
   
            Button("Log out") {
                Task {
                    do {
                        try viewModel.logOut()
                        showSignInView = true
                        print("Mali PP")
                    } catch {
                        print(error)
                    }
                }
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }
}
