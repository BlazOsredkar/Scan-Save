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
            SettingsView(showSignInView: $showSignInView)
                .tabItem() {
                    Image(systemName: "gear.circle.fill")
                    Text("Settings")
                }
            QRCodeView()
                .tabItem() {
                    Image(systemName: "house.fill")
                    Text("QR")
                }
        }
    }
}

#Preview {
    MenuBarView(showSignInView: .constant(false))
}
