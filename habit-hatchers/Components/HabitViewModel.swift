//
//  ContentViewModel.swift
//  habit-hatchers
//
//  Created by Jesse Tzo on 7/4/24.
//

import SwiftUI
import Combine

class HabitViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var pastHabits: [Habit] = []
    @Published var isLoading = true
    @Published var errorMessage: String?
    
    init() {
        loadJsonData()
    }
    
    func loadJsonData() {
        print("HABITS ARE:")
        print(habits)
        DispatchQueue.global(qos: .background).async {
            // loads data from currentHabitData.json
            if let currentHabitJsonData = getJsonData(fileName: "currentHabitData.json") {
                do {
                    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                        print("Documents directory not found")
                        return
                    }
                    
                    // Append the file name to the documents directory URL
                    let currentHabitDataFile = documentsDirectory.appendingPathComponent("currentHabitData.json")
                    
                    if (isEmptyFile(fileURL: currentHabitDataFile)) {
                        self.habits = []
                        self.isLoading = false
                    }
                    
                    else {
                        let habits = try JSONDecoder().decode([Habit].self, from: currentHabitJsonData)
                        DispatchQueue.main.async {
                            self.habits = habits
                            self.isLoading = false
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = "Error decoding JSON data: \(error.localizedDescription)"
                        self.isLoading = false
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to retrieve JSON data"
                    self.isLoading = false
                }
            }
            
            // loads data from pastHabitData.json
            if let pastHabitJsonData = getJsonData(fileName: "pastHabitData.json") {
                do {
                    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                        print("Documents directory not found")
                        return
                    }

                    // Append the file name to the documents directory URL
                    let pastHabitDataFile = documentsDirectory.appendingPathComponent("pastHabitData.json")
                    
                    if (isEmptyFile(fileURL: pastHabitDataFile)) {
                        self.pastHabits = []
                        self.isLoading = false
                    }
                    
                    let pastHabits = try JSONDecoder().decode([Habit].self, from: pastHabitJsonData)
                                        
                    DispatchQueue.main.async {
                        self.pastHabits = pastHabits
                        self.isLoading = false
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = "Error decoding JSON data: \(error.localizedDescription)"
                        self.isLoading = false
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to retrieve JSON data"
                    self.isLoading = false
                }
            }
        }
    }
}
