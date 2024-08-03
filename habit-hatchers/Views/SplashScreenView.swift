//
//  SplashScreenView.swift
//  habit-hatchers
//
//  Created by Jesse Tzo on 6/3/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9137254902, alpha: 1)).ignoresSafeArea()
            
            Text("Habit\nHatchers!")
                .font(Font.custom("Inika-Bold", size: 50))
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    SplashScreenView()
}
