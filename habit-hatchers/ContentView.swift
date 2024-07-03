//
//  ContentView.swift
//  habit-hatchers
//
//  Created by Jesse Tzo on 5/18/24.
//

import SwiftUI
import UIKit
extension UIScrollView {  open override var clipsToBounds: Bool {   get { false }   set { }  } }

struct ContentView: View {  
    // State Variables
    @State private var fulfilled = 0
    @State private var numOfEggs = 3
    @State private var displayState = true
    @State private var displayHabit = " "
    @State private var showAddEggView = false

    
    
    
    
    
    @State private var habits: [Habit] = [
        Habit(habitName: "Run"),
        Habit(habitName: "Fight"),
        Habit(habitName: "Jump")
    ]
    
    // ContentView
    var body: some View {
        NavigationView {
            // Main Chicken
            let chickenImageName = fulfilled == numOfEggs ? "chicken_in_egg" : "chicken_in_egg_sad"
            
            ZStack {
                // ContentView Background
                Color(#colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9137254902, alpha: 1)).ignoresSafeArea()
                    .onTapGesture {
                        print("Tapped Screen")
                        displayHabit = " "
                    }
                
                // Settings Button
                VStack {
                    HStack {
                        Spacer().frame(maxWidth: 300)
                        Button(action: {
                            print("Settings tapped")
                        }) {
                            Image("settings")
                                .resizable()
                                .background(Color.clear)
                                .frame(width: 37, height: 37)
                        }
                    }
                    
                    Image(chickenImageName)
                        .resizable()
                        .background(Color.clear)
                        .frame(width: 350, height: 350)
                    
                    // ScrollView
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: -10) {
                            if numOfEggs == 0 {
                                // FIX THIS (when all eggs are removed)
                                //                                HabitEggButton(habit: .constant(Habit(habitName: "Temp"))).opacity(0)
                            } else {
                                ForEach($habits) { $habit in
                                    if habit.isDisplayed {
                                        HabitEggButton(habit: $habit, displayHabit: $displayHabit)
                                    }
                                }
                                
                                // Add HabitEgg Button
                                Button(action: {
                                    print("Add tapped")
                                    showAddEggView = true
                                }) {
                                    Image("add-button")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .offset(x: -28, y: 10)
                                        .frame(width: 180, height: 100)
                                }
                            }
                        }
                    }
                    .offset(x: 25)
                    .sheet(isPresented: $showAddEggView) {
                        AddEggView()
                    }
                    
                    // Habit Text Display
                    Text(displayHabit)
                        .font(Font.custom("Inika-Bold", size: 26))
                        .opacity(displayHabit == "" ? 0 : 1)
                        .offset(y: 50)
                }
                .offset(y: -65)
            }
        }.navigationBarHidden(true)
    }
}


#Preview {
    ContentView()
}
