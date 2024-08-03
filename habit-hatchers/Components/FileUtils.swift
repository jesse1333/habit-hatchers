//
//  FileUtils.swift
//  habit-hatchers
//
//  Created by Jesse Tzo on 7/4/24.
//

import Foundation

func addJsonToFile(fileName: String, jsonString: String) {
    // Get the URL of the documents directory
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        print("Documents directory not found")
        return
    }
    
    // Append the file name to the documents directory URL
    let habitDataURL = documentsDirectory.appendingPathComponent(fileName)
    
    do {
        if FileManager.default.fileExists(atPath: habitDataURL.path) {
            // File exists, append to existing content
            var existingData = try Data(contentsOf: habitDataURL)
            
            // Remove trailing ']' if it exists
            if let lastChar = existingData.last, lastChar == UInt8(ascii: "]") {
                existingData.removeLast()
            }
            
            // If there's existing data, add a comma to separate objects
            if !isEmptyFile(fileURL: habitDataURL) {
                print("has content")
                existingData.append(contentsOf: ", ".data(using: .utf8)!)
            } else {
                print("empty")
                existingData.append(contentsOf: "[ ".data(using: .utf8)!)
            }
            
            // Convert the new JSON string to data and append to existing data
            if let jsonData = jsonString.data(using: .utf8) {
                existingData.append(jsonData)
                
                // Append ']' to complete the array
                existingData.append(UInt8(ascii: "]"))
                
                // Write the updated data back to the file
                try existingData.write(to: habitDataURL, options: .atomic)
            } else {
                print("Failed to convert JSON string to data")
            }
            
            print("Json data appended successfully to: \(habitDataURL)")
        } else {
            // File doesn't exist, create a new file with the JSON data wrapped in an array
            let wrappedJsonString = "[\(jsonString)]"
            try wrappedJsonString.write(to: habitDataURL, atomically: true, encoding: .utf8)
            print("Json data saved successfully to a new file: \(habitDataURL)")
        }
    } catch {
        print("Error appending json data: \(error)")
    }
}

func getJsonData(fileName: String) -> Data? {
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        print("Documents directory not found")
        return nil
    }
    
    let fileURL = documentsDirectory.appendingPathComponent(fileName)
    do {
        // Read data from the file
        let data = try Data(contentsOf: fileURL)
        print("Data Found!")
        return data
    } catch {
        print("Error reading JSON data: \(error)")
        return nil
    }
}

func deleteJsonData(habitID: String, currentFile: String, pastFile: String) {
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM-dd-yyyy"
    let formattedDate = dateFormatter.string(from: currentDate)
    
    
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        print("Documents directory not found")
        return
    }
    
    let currentFileURL = documentsDirectory.appendingPathComponent(currentFile)
    do {
        // Read data from the current file
        let currentData = try Data(contentsOf: currentFileURL)
        var objects = try JSONSerialization.jsonObject(with: currentData, options: []) as! [[String: Any]]
        
        // Find index of object with matching ID
        if let index = objects.firstIndex(where: { $0["id"] as? String == habitID }) {
            
            var deletedObject = objects.remove(at: index)
            deletedObject["endDate"] = formattedDate
            
            // Edge case of only one object in json file
            if objects.count == 0 {
                try "".write(to: currentFileURL, atomically: false, encoding: .utf8)
            }
            
            else {
                
                // Serialize array back to JSON data with sorted keys and pretty printed
                let updatedJsonData = try JSONSerialization.data(withJSONObject: objects, options: [.prettyPrinted, .sortedKeys])
                
                print(updatedJsonData)
                // Write updated JSON data back to current file
                try updatedJsonData.write(to: currentFileURL)
            }
            
            print("Object with ID \(habitID) deleted successfully.")
            
            
            // Append the deleted object to the past file
            let pastFileURL = documentsDirectory.appendingPathComponent(pastFile)
            
            do {
                if FileManager.default.fileExists(atPath: pastFileURL.path) {
                    // File exists, append to existing content
                    var existingData = try Data(contentsOf: pastFileURL)
                    
                    // Remove trailing ']' if it exists
                    if let lastChar = existingData.last, lastChar == UInt8(ascii: "]") {
                        existingData.removeLast()
                    }
                    
                    // If there's existing data, add a comma to separate objects
                    if !isEmptyFile(fileURL: pastFileURL) {
                        print("has content")
                        existingData.append(contentsOf: ", ".data(using: .utf8)!)
                    } else {
                        print("empty")
                        existingData.append(contentsOf: "[ ".data(using: .utf8)!)
                    }
                    
                    // Convert the new JSON string to data and append to existing data
                    let jsonData = try JSONSerialization.data(withJSONObject: deletedObject)
                    existingData.append(jsonData)
                    
                    // Append ']' to complete the array
                    existingData.append(UInt8(ascii: "]"))
                    
                    // Write the updated data back to the file
                    try existingData.write(to: pastFileURL, options: .atomic)
                    
                    
                    print("Json data appended successfully to: \(pastFileURL)")
                } else {
                    // File doesn't exist, create a new file with the JSON data wrapped in an array
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: deletedObject, options: [])

                    let jsonString = String(data: jsonData, encoding: .utf8)!
   
                    
                    print(jsonString)
                    let wrappedJsonString = "[\(jsonString)]"
                    try wrappedJsonString.write(to: pastFileURL, atomically: true, encoding: .utf8)
                    print("Json data saved successfully to a new file: \(pastFileURL)")
                }
            } catch {
                print("Error appending json data: \(error)")
            }
            
        } else {
            print("Object with ID \(habitID) not found.")
        }
        
    } catch {
        print("Error reading or manipulating JSON data: \(error.localizedDescription)")
    }
}

func deleteJsonData(habitID: String, fileName: String) {
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        print("Documents directory not found")
        return
    }
    
    let currentFileURL = documentsDirectory.appendingPathComponent(fileName)
    
    do {
        // Read data from the current file
        let currentData = try Data(contentsOf: currentFileURL)
        var objects = try JSONSerialization.jsonObject(with: currentData, options: []) as! [[String: Any]]
        
        // Find index of object with matching ID
        if let index = objects.firstIndex(where: { $0["id"] as? String == habitID }) {
            
            let deletedObject = objects.remove(at: index)

            // Edge case of only one object in json file
            if objects.count == 0 {
                try "".write(to: currentFileURL, atomically: false, encoding: .utf8)
            }
            
            else {
                // Remove object from array and get the deleted object
                
                print(deletedObject)
                
                // Serialize array back to JSON data with sorted keys and pretty printed
                let updatedJsonData = try JSONSerialization.data(withJSONObject: objects, options: [.prettyPrinted, .sortedKeys])
                
                print(updatedJsonData)
                // Write updated JSON data back to current file
                try updatedJsonData.write(to: currentFileURL)
            }
            
            print("Object with ID \(habitID) deleted successfully.")
            
        } else {
            print("Object with ID \(habitID) not found.")
        }
        
    } catch {
        print("Error reading or manipulating JSON data: \(error.localizedDescription)")
    }
}

func restoreJsonData(habitID: String, currentFile: String, pastFile: String) {
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        print("Documents directory not found")
        return
    }
    
    let pastFileURL = documentsDirectory.appendingPathComponent(pastFile)
    do {
        // Read data from the current file
        let pastData = try Data(contentsOf: pastFileURL)
        var objects = try JSONSerialization.jsonObject(with: pastData, options: []) as! [[String: Any]]
        
        // Find index of object with matching ID
        if let index = objects.firstIndex(where: { $0["id"] as? String == habitID }) {
            
            var deletedObject = objects.remove(at: index)
            
            deletedObject["streak"] = 0
            
            // Edge case of only one object in json file
            if objects.count == 0 {
                try "".write(to: pastFileURL, atomically: false, encoding: .utf8)
            }
            
            else {
                
                // Serialize array back to JSON data with sorted keys and pretty printed
                let updatedJsonData = try JSONSerialization.data(withJSONObject: objects, options: [.prettyPrinted, .sortedKeys])
                
                print(updatedJsonData)
                // Write updated JSON data back to current file
                try updatedJsonData.write(to: pastFileURL)
            }
            
            print("Object with ID \(habitID) deleted successfully.")
            
            
            // Append the deleted object to the current file
            let currentFileURL = documentsDirectory.appendingPathComponent(currentFile)
            
            do {
                if FileManager.default.fileExists(atPath: currentFileURL.path) {
                    // File exists, append to existing content
                    var existingData = try Data(contentsOf: currentFileURL)
                    
                    // Remove trailing ']' if it exists
                    if let lastChar = existingData.last, lastChar == UInt8(ascii: "]") {
                        existingData.removeLast()
                    }
                    
                    // If there's existing data, add a comma to separate objects
                    if !isEmptyFile(fileURL: currentFileURL) {
                        print("has content")
                        existingData.append(contentsOf: ", ".data(using: .utf8)!)
                    } else {
                        print("empty")
                        existingData.append(contentsOf: "[ ".data(using: .utf8)!)
                    }
                    
                    // Convert the new JSON string to data and append to existing data
                    let jsonData = try JSONSerialization.data(withJSONObject: deletedObject)
                    existingData.append(jsonData)
                    
                    // Append ']' to complete the array
                    existingData.append(UInt8(ascii: "]"))
                    
                    // Write the updated data back to the file
                    try existingData.write(to: currentFileURL, options: .atomic)
                    
                    
                    print("Json data appended successfully to: \(currentFileURL)")
                } else {
                    // File doesn't exist, create a new file with the JSON data wrapped in an array
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: deletedObject, options: [])

                    let jsonString = String(data: jsonData, encoding: .utf8)!
   
                    
                    print(jsonString)
                    let wrappedJsonString = "[\(jsonString)]"
                    try wrappedJsonString.write(to: currentFileURL, atomically: true, encoding: .utf8)
                    print("Json data saved successfully to a new file: \(currentFileURL)")
                }
            } catch {
                print("Error appending json data: \(error)")
            }
            
        } else {
            print("Object with ID \(habitID) not found.")
        }
        
    } catch {
        print("Error reading or manipulating JSON data: \(error.localizedDescription)")
    }
}



func isEmptyFile(fileURL: URL) -> Bool {
    do {
        let fileContents = try String(contentsOf: fileURL, encoding: .utf8)
        print("File contains: " + fileContents)
        return fileContents.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    } catch {
        print("Error reading file: \(error)")
        return true // If there's an error reading the file, we can assume it's empty or inaccessible
    }
}

func getItemCount(fileName: String) -> Int {
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Documents directory not found")
            return -1
        }
        
        // Append the file name to the documents directory URL
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
    
        // case of empty file
        if isEmptyFile(fileURL: fileURL) {
            return -2
        }
        
        do {
            // Read data from the file
            let jsonData = try Data(contentsOf: fileURL)
            
            // Deserialize JSON data into an array of dictionaries
            let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [[String: Any]]
            
            // Return the number of objects (elements) in the array
            return jsonArray.count

    } catch {
        print("Error reading file: \(error)")
        return -1
    }
}
