//
//  EggCollectionElement.swift
//  habit-hatchers
//
//  Created by Jesse Tzo on 7/11/24.
//

import SwiftUI

struct SettingsEggElement: View {
    @ObservedObject var viewModel : HabitViewModel
    var habitName : String
    var id: UUID
    var streakValue: String
    var settingsEggType: String
    @Binding var numOfEggs: Int
    @Binding var displayHabit : String
    
    @State private var habitNameString = ""
    @State private var habitIDString = ""
    @State private var showHabitInfoView = false
    @State private var habitType = ""
    @State private var totalCollected = 0
    @State private var currentStreak = 0
    @State private var activeDays = 0
    @State private var started = ""
    @State private var ended = "---"
    
    var body: some View {
        HStack {
            // Left side content
            HStack {
                // Egg Info Button
                Button(action: {
                    habitNameString = getHabitName(id: self.id, settingsEggType: settingsEggType)
                    habitIDString = self.id.uuidString
                    habitType = getHabitType(id: self.id, settingsEggType: settingsEggType)
                    totalCollected = getTotalCollected(id: self.id, settingsEggType: settingsEggType)
                    currentStreak = getCurrentStreak(id: self.id, settingsEggType: settingsEggType)
                    activeDays = getActiveDays(id: self.id, settingsEggType: settingsEggType)
                    started = getStartDate(id: self.id, settingsEggType: settingsEggType)
                    ended = getEndDate(id: self.id, settingsEggType: settingsEggType)
                    showHabitInfoView = true
                    
                }) {
                    Image("egg_uncracked")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .frame(width: 70, height: 70)
                
                
                // Habit Egg Text
                Text(habitName).font(Font.custom("Inika-Bold", size: 25)).offset(x: -10, y: 5)
                    .fixedSize()
            }.offset(x: 25)
            
            Spacer()
            
            // Right side content
            HStack {
                if settingsEggType == "current" {
                    // Streak Button
                    Button(action: {
                        print("Streak tapped")
                        
                    }) {
                        Image("fire")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .frame(width: 45, height: 45)
                    
                    // Streak Text
                    Text(streakValue + " d").font(Font.custom("Inika-Bold", size: 25)).fixedSize().offset(y: -2)
                    
                }
                else if settingsEggType == "past" {
                    // Calendar Button
                    Button(action: {
                        print("Calendar tapped")
                        
                    }) {
                        Image("calendar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .frame(width: 45, height: 45)
                    
                    // Calendar Text
                    Text(streakValue + " d").font(Font.custom("Inika-Bold", size: 25)).fixedSize().offset(y: -2)
                }
            }.offset(x: -35, y: 5)
        }
        .sheet(isPresented: $showHabitInfoView) {
            HabitInfoView(viewModel: viewModel,
                          numOfEggs: $numOfEggs, displayHabit: $displayHabit, settingsEggType: settingsEggType, habitNameString: $habitNameString, showHabitInfoView: $showHabitInfoView, habitIDString: $habitIDString,
                          habitType: $habitType,
                          totalCollected: $totalCollected,
                          currentStreak: $currentStreak,
                          activeDays: $activeDays, started: $started,
                          ended: $ended)
        }
    }
}

func getHabitName(id: UUID, settingsEggType: String) -> String {
    var fileName = ""
    if settingsEggType == "current" {
        fileName = "currentHabitData.json"
    }
    else if settingsEggType == "past" {
        fileName = "pastHabitData.json"
    }
    
    print("FILE NAME")
    print(fileName)
    
    do {
        if let jsonData = getJsonData(fileName: fileName) {
            let habits = try JSONDecoder().decode([Habit].self, from: jsonData)
            print("Successfully decoded habits: \(habits)")
            
            if let habit = habits.first(where: { $0.id == id }) {
                let habitName = habit.habitName
                print("Start Date for habit with id \(id): \(habitName)")
                return habit.habitName
                
            } else {
                print("Habit with id not found")
            }
        } else {
            print("Failed to get JSON data")
        }
        
    } catch {
        print("Error decoding JSON: \(error)")
    }
    
    return "NIL"
}

func getTotalCollected(id: UUID, settingsEggType: String) -> Int {
    var fileName = ""
    if settingsEggType == "current" {
        fileName = "currentHabitData.json"
    }
    else if settingsEggType == "past" {
        fileName = "pastHabitData.json"
    }
    
    do {
        if let jsonData = getJsonData(fileName: fileName) {
            let habits = try JSONDecoder().decode([Habit].self, from: jsonData)
            print("Successfully decoded habits: \(habits)")
            
            if let habit = habits.first(where: { $0.id == id }) {
                print("Total collected for habit with id \(id): \(habit.totalCollected)")
                
                return habit.totalCollected
                
            } else {
                print("Habit with id not found")
            }
        } else {
            print("Failed to get JSON data")
        }
        
    } catch {
        print("Error decoding JSON: \(error)")
    }
    
    return -1
}

func getCurrentStreak(id: UUID, settingsEggType: String) -> Int {
    var fileName = ""
    if settingsEggType == "current" {
        fileName = "currentHabitData.json"
    }
    else if settingsEggType == "past" {
        fileName = "pastHabitData.json"
    }
    
    do {
        if let jsonData = getJsonData(fileName: fileName) {
            let habits = try JSONDecoder().decode([Habit].self, from: jsonData)
            print("Successfully decoded habits: \(habits)")
            
            if let habit = habits.first(where: { $0.id == id }) {
                let totalCollected = habit.totalCollected
                print("Streak for habit with id \(id): \(totalCollected)")
                return habit.streak
                
            } else {
                print("Habit with id not found")
            }
        } else {
            print("Failed to get JSON data")
        }
        
    } catch {
        print("Error decoding JSON: \(error)")
    }
    
    return -1
}

func getStartDate(id: UUID, settingsEggType: String) -> String {
    var fileName = ""
    if settingsEggType == "current" {
        fileName = "currentHabitData.json"
    }
    else if settingsEggType == "past" {
        fileName = "pastHabitData.json"
    }
    
    do {
        if let jsonData = getJsonData(fileName: fileName) {
            let habits = try JSONDecoder().decode([Habit].self, from: jsonData)
            print("Successfully decoded habits: \(habits)")
            
            if let habit = habits.first(where: { $0.id == id }) {
                let startDate = habit.startDate
                print("Start Date for habit with id \(id): \(startDate)")
                return habit.startDate
                
            } else {
                print("Habit with id not found")
            }
        } else {
            print("Failed to get JSON data")
        }
        
    } catch {
        print("Error decoding JSON: \(error)")
    }
    
    return "NIL"
}

func getEndDate(id: UUID, settingsEggType: String) -> String {
    if settingsEggType == "current" {
        return "---"
    }
    else if settingsEggType == "past" {
        do {
            if let jsonData = getJsonData(fileName: "pastHabitData.json") {
                let habits = try JSONDecoder().decode([Habit].self, from: jsonData)
                print("Successfully decoded habits: \(habits)")
                
                if let habit = habits.first(where: { $0.id == id }) {
                    let endDate = habit.endDate
                    print("End Date for habit with id \(id): \(endDate)")
                    return habit.endDate
                    
                } else {
                    print("Habit with id not found")
                }
            } else {
                print("Failed to get JSON data")
            }
            
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    return "NIL"
}

func getHabitType(id: UUID, settingsEggType: String) -> String {
    var fileName = ""
    if settingsEggType == "current" {
        fileName = "currentHabitData.json"
    }
    else if settingsEggType == "past" {
        fileName = "pastHabitData.json"
    }
    
    do {
        if let jsonData = getJsonData(fileName: fileName) {
            let habits = try JSONDecoder().decode([Habit].self, from: jsonData)
            print("Successfully decoded habits: \(habits)")
            
            if let habit = habits.first(where: { $0.id == id }) {
                let habitType = habit.habitType
                print("Habit type for habit with id \(id): \(habitType)")
                return habit.habitType
                
            } else {
                print("Habit with id not found")
            }
        } else {
            print("Failed to get JSON data")
        }
        
    } catch {
        print("Error decoding JSON: \(error)")
    }
    
    return "NIL"
}

func getActiveDays(id: UUID, settingsEggType: String) -> Int {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM-dd-yyyy"
    
    let startDateString = getStartDate(id: id, settingsEggType: settingsEggType)
    let endDateString = getEndDate(id: id, settingsEggType: settingsEggType)
    
    guard let startDate = dateFormatter.date(from: startDateString),
          let endDate = dateFormatter.date(from: endDateString) else {
        return -1
    }
    
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day], from: startDate, to: endDate)
    
    return components.day ?? -1
}


#Preview {
    struct SettingsEggElementPreviewContainer : View {
        @State private var numOfEggs = 0
        @State private var habitNameString = "Test"
        @State private var habitID = UUID()
        @State private var showHabitInfoView = false
        @State private var streakValue = "14"
        @State private var displayHabit = " "
        
        var body: some View {
            SettingsEggElement(viewModel: HabitViewModel(), habitName: habitNameString, id: habitID, streakValue: streakValue, settingsEggType: "current", numOfEggs: $numOfEggs, displayHabit: $displayHabit)
        }
    }
    
    return SettingsEggElementPreviewContainer()
}
