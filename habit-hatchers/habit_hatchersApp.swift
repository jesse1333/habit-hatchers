//
//  habit_hatchersApp.swift
//  habit-hatchers
//
//  Created by Jesse Tzo on 5/18/24.
//

import SwiftUI

@main
struct habit_hatchersApp: App {
    let defaults = UserDefaults.standard
    
    @State private var showSplashScreen = true
    
    
    var body: some Scene {
            WindowGroup {
                ZStack {
                    ContentView()
                        .opacity(showSplashScreen ? 0 : 1)
                        .animation(.easeInOut(duration: 0.3), value: showSplashScreen)
                    
                    if showSplashScreen {
                        SplashScreenView()
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.25) {
                        withAnimation(.easeInOut(duration: 1)) {
                            showSplashScreen = false
                        }
                    }
                }
            }
        }
    
    func checkFirstLaunch() {
        if !defaults.bool(forKey: "firstTimeUser") {
            defaults.set(true, forKey: "firstTimeUser")
            print("First time launching the app")
            // Perform any first-time setup here
        } else {
            print("App has launched before")
            // App has already been launched
        }
    }
}
