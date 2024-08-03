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
    @ObservedObject var viewModel : HabitViewModel
    @Binding var habit : Habit
    @Binding var displayHabit: String
    @Binding var collected: Int
    @Binding var numOfEggs: Int
    
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
            // when egg button is held
            habit.isDisplayed = false
            self.displayHabit = " "
            updateIsDisplayed(habitID: habit.id)
            incrementCollected(habitID: habit.id)
            updateStreak(habitID: habit.id)
            collected = getTotalCollected()
            viewModel.loadJsonData()
            
            if collected == numOfEggs {
                displayHabit = "Eggs Collected!"
            }
            
            print(habit.habitName + " button held")
        }
    }
}

func getTotalCollected() -> Int {
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        print("Documents directory not found")
        return -1
    }
    
    let currentFileURL = documentsDirectory.appendingPathComponent("currentHabitData.json")
    
    do {
        // Read data from the current file
        let data = try Data(contentsOf: currentFileURL)
        let items = try JSONDecoder().decode([Habit].self, from: data)
        
        var count = 0
        for item in items {
            if item.isDisplayed == false {
                count += 1
            }
        }
        
        return count
        
        
    } catch {
        print("Error reading or manipulating JSON data: \(error.localizedDescription)")
    }
    
    return -1
}

func incrementCollected(habitID: UUID) {
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        print("Documents directory not found")
        return
    }
    
    let currentFileURL = documentsDirectory.appendingPathComponent("currentHabitData.json")
    
    do {
        // Read data from the current file
        let currentData = try Data(contentsOf: currentFileURL)
        var objects = try JSONSerialization.jsonObject(with: currentData, options: []) as! [[String: Any]]
        
        // Find index of object with matching ID
        if let index = objects.firstIndex(where: { $0["id"] as? String == habitID.uuidString }) {
            if var totalCollected = objects[index]["totalCollected"] as? Int {
                totalCollected += 1
                objects[index]["totalCollected"] = totalCollected
            } else {
                print("Error: 'totalCollected' is not an integer.")
                return
            }
            
            // Serialize array back to JSON data with sorted keys and pretty printed
            let updatedJsonData = try JSONSerialization.data(withJSONObject: objects, options: [.prettyPrinted, .sortedKeys])
            
            // Write updated JSON data back to current file
            try updatedJsonData.write(to: currentFileURL)
            
            print("Object with ID \(habitID) updated successfully.")
            
        } else {
            print("Object with ID \(habitID) not found.")
        }
        
    } catch {
        print("Error reading or manipulating JSON data: \(error.localizedDescription)")
    }
}

func updateIsDisplayed(habitID: UUID) {
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        print("Documents directory not found")
        return
    }
    
    let currentFileURL = documentsDirectory.appendingPathComponent("currentHabitData.json")
    
    do {
        // Read data from the current file
        let currentData = try Data(contentsOf: currentFileURL)
        var objects = try JSONSerialization.jsonObject(with: currentData, options: []) as! [[String: Any]]
        
        // Find index of object with matching ID
        if let index = objects.firstIndex(where: { $0["id"] as? String == habitID.uuidString }) {
            
            objects[index]["isDisplayed"] = false
            
            // Serialize array back to JSON data with sorted keys and pretty printed
            let updatedJsonData = try JSONSerialization.data(withJSONObject: objects, options: [.prettyPrinted, .sortedKeys])
            
            // Write updated JSON data back to current file
            try updatedJsonData.write(to: currentFileURL)
            
            print("Object with ID \(habitID) updated successfully.")
            
        } else {
            print("Object with ID \(habitID) not found.")
        }
        
    } catch {
        print("Error reading or manipulating JSON data: \(error.localizedDescription)")
    }
}

func updateStreak(habitID: UUID) {
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        print("Documents directory not found")
        return
    }
    
    let currentFileURL = documentsDirectory.appendingPathComponent("currentHabitData.json")
    
    do {
        // Read data from the current file
        let currentData = try Data(contentsOf: currentFileURL)
        var objects = try JSONSerialization.jsonObject(with: currentData, options: []) as! [[String: Any]]
        
        // Find index of object with matching ID
        if let index = objects.firstIndex(where: { $0["id"] as? String == habitID.uuidString }) {
            
            if var streak = objects[index]["streak"] as? Int {
                streak += 1
                objects[index]["streak"] = streak
            } else {
                print("Error: 'streak' is not an integer.")
                return
            }
            
            
            // Serialize array back to JSON data with sorted keys and pretty printed
            let updatedJsonData = try JSONSerialization.data(withJSONObject: objects, options: [.prettyPrinted, .sortedKeys])
            
            // Write updated JSON data back to current file
            try updatedJsonData.write(to: currentFileURL)
            
            print("Object with ID \(habitID) updated successfully.")
            
        } else {
            print("Object with ID \(habitID) not found.")
        }
        
    } catch {
        print("Error reading or manipulating JSON data: \(error.localizedDescription)")
    }
}

func resetIsDisplayed() {
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        print("Documents directory not found")
        return
    }
    
    let currentFileURL = documentsDirectory.appendingPathComponent("currentHabitData.json")
    
    do {
        // Read data from the current file
        let currentData = try Data(contentsOf: currentFileURL)
        var objects = try JSONSerialization.jsonObject(with: currentData, options: []) as! [[String: Any]]
        
        for index in objects.indices {
            objects[index]["isDisplayed"] = true
        }
        
        // Serialize array back to JSON data with sorted keys and pretty printed
        let updatedJsonData = try JSONSerialization.data(withJSONObject: objects, options: [.prettyPrinted, .sortedKeys])
        
        // Write updated JSON data back to current file
        try updatedJsonData.write(to: currentFileURL)
        
        print("All Habit 'isDisplayed' have been reset")
        
    } catch {
        print("Error reading or manipulating JSON data: \(error.localizedDescription)")
    }
}

func resetStreak() {
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        print("Documents directory not found")
        return
    }
    
    let currentFileURL = documentsDirectory.appendingPathComponent("currentHabitData.json")
    
    do {
        // Read data from the current file
        let currentData = try Data(contentsOf: currentFileURL)
        var objects = try JSONSerialization.jsonObject(with: currentData, options: []) as! [[String: Any]]
        
        for index in objects.indices {
            if let isDisplayed = objects[index]["isDisplayed"] as? Bool, isDisplayed {
                objects[index]["streak"] = 0
            }
        }
        
        print("Resetting")
        
        // Serialize array back to JSON data with sorted keys and pretty printed
        let updatedJsonData = try JSONSerialization.data(withJSONObject: objects, options: [.prettyPrinted, .sortedKeys])
        
        // Write updated JSON data back to current file
        try updatedJsonData.write(to: currentFileURL)
        
        print("All Habit 'isDisplayed' have been reset")
        
    } catch {
        print("Error reading or manipulating JSON data: \(error.localizedDescription)")
    }
}
