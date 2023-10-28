//
//  MenuBarView.swift
//  Scan&Save
//
//  Created by Blaž Osredkar on 28. 10. 23.
//

import SwiftUI

struct MenuBarView: View {
    
    @Binding var showSignInView: Bool
    var body: some View {
        
        TabView {
            HomeView()
                .tabItem() {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            SettingsView(showSignInView: .constant(false))
                .tabItem() {
                    Image(systemName: "gear.circle.fill")
                    Text("Settings")
                }
        }
    }
}

#Preview {
    MenuBarView(showSignInView: .constant(false))
}