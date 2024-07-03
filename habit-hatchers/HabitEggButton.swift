//
//  HabitEggButton.swift
//  habit-hatchers
//
//  Created by Jesse Tzo on 5/22/24.
//

import Foundation
import SwiftUI
import SwiftData

struct HabitEggButton: View {
    @Binding var habit : Habit
    @Binding var displayHabit: String
    
    var body: some View {
        Button(action: {
            
            print(habit.habitName + " button tapped")
            if habit.isDisplayed {
                self.displayHabit = self.habit.habitName
                print("Yes")
            }
            else {
                print("No")
            }
        }) {
            Image("egg_uncracked")
                .resizable()
                .frame(width: 120, height: 120)
        }
        .supportsLongPress {
            habit.isDisplayed = false
            self.displayHabit = " "
            print(habit.habitName + " button held")
        }
    }
}
