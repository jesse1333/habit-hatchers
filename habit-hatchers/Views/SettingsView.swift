//
//  SettingsView.swift
//  habit-hatchers
//
//  Created by Jesse Tzo on 7/8/24.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel : HabitViewModel
    @Binding var numOfEggs : Int
    @Binding var displayHabit : String
    
    @State private var inputHabit: String = ""
    @State private var hasPast = true
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9137254902, alpha: 1)).ignoresSafeArea()
            
            VStack {
                // Current Eggs
                Text("Current Eggs:").font(Font.custom("Inika-Bold", size: 30))
                ScrollView {
                    // Vertical Entry Stack
                    VStack {
                        if viewModel.isLoading {
                            Text("Loading data...")
                        }
                        else {
                            ForEach($viewModel.habits) { $habit in
                                SettingsEggElement(viewModel: viewModel, habitName: habit.habitName, id: habit.id, streakValue: String(habit.streak), settingsEggType: "current", numOfEggs: $numOfEggs, displayHabit: $displayHabit)
                            }
                        }
                    }
                }.clipped()
                
                
                if (hasPast) {
                    // Past Eggs
                    Text("Past Eggs:").font(Font.custom("Inika-Bold", size: 30))
                    ScrollView {
                        // Vertical Entry Stack
                        VStack {
                            if viewModel.isLoading {
                                Text("Loading data...")
                            }
                            else {
                                ForEach($viewModel.pastHabits) { $habit in
                                    SettingsEggElement(viewModel: viewModel, habitName: habit.habitName, id: habit.id, streakValue: String(getActiveDays(id: habit.id, settingsEggType: "past")), settingsEggType: "past", numOfEggs: $numOfEggs, displayHabit: $displayHabit)
                                }
                            }
                        }
                    }.clipped()
                }
                
            }.padding(.top, 50)
        }
    }
}

struct SettingsViewPreview: PreviewProvider {
    static var previews: some View {
        @State var numOfEggs = 0
        @State var displayHabit = " "
        
        SettingsView(viewModel: HabitViewModel(), numOfEggs: $numOfEggs, displayHabit: $displayHabit)
    }
}
