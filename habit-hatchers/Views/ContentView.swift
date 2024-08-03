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
    @State private var collected = getTotalCollected()
    @State private var numOfEggs = getItemCount(fileName: "currentHabitData.json")
    @State private var displayState = true
    @State private var displayHabit = " "
    @State private var showAddEggView = false
    @State private var showSettingsView = false
    @State private var loadJsonData = true
    
    // For Array of Habit Structs (loaded on initialization)
    @StateObject var viewModel = HabitViewModel()
    
    private let calendarDayChangedObserver = NotificationCenter.default.addObserver(forName: .NSCalendarDayChanged, object: nil, queue: .main) { _ in
        print("Calendar day changed - Eggs have been reset")
        resetStreak()
        resetIsDisplayed()
    }
    
    // ContentView
    var body: some View {
        NavigationStack {
            // Main Chicken
            //            let chickenImageName = fulfilled == numOfEggs ? "chicken_in_egg" : "chicken_in_egg_sad"
            let chickenImageName = "chicken_in_egg"
            
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
                            showSettingsView = true
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
                            if viewModel.isLoading {
                                Text("Loading data...")
                            }
                            else {
                                ForEach($viewModel.habits) { $habit in
                                    if habit.isDisplayed {
                                        HabitEggButton(viewModel: viewModel, habit: $habit, displayHabit: $displayHabit, collected: $collected, numOfEggs: $numOfEggs)
                                    }
                                }
                                
                                // Add HabitEgg Button
                                Button(action: {
                                    print("Add tapped")
                                    print(String(collected))
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
                        AddEggView(viewModel: viewModel, numOfEggs: $numOfEggs)
                    }
                    .sheet(isPresented: $showSettingsView) {
                        SettingsView(viewModel: viewModel, numOfEggs: $numOfEggs, displayHabit: $displayHabit)
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
