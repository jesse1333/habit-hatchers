//
//  SheetView.swift
//  habit-hatchers
//
//  Created by Jesse Tzo on 7/3/24.
//

import Foundation
import SwiftUI

struct AddEggView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var inputHabit: String = ""
    @ObservedObject var viewModel : HabitViewModel
    @Binding var numOfEggs : Int
    
    // date variables
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9137254902, alpha: 1)).ignoresSafeArea()
            
            VStack {
                // Add a Habit
                Text("Add a Habit!").font(Font.custom("Inika-Bold", size: 35))
                
                Image("egg_uncracked")
                    .resizable()
                    .frame(width: 220, height: 220)
                
                // Text-Field
                TextField("Please enter a habit", text: $inputHabit)
                    .font(Font.custom("Inika", size: 14))
                    .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .frame(width: 200, height: 100)
                
                // Submit Button
                Button(action: {
                    print("Egg Submitted")
                    
                    // formats date
                    dateFormatter.dateFormat = "MM-dd-yyyy"
                    let formattedDate = dateFormatter.string(from: currentDate)
                    
                    if inputHabit != "" {
                        
                        guard FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first != nil else {
                            print("Documents directory not found")
                            return
                        }
                        
                        do {
                            let habit = Habit(habitName: inputHabit, habitType: "daily", totalCollected: 0, streak: 0, daysKept: 0, startDate: formattedDate, endDate: "---")
                            let jsonData = try JSONEncoder().encode(habit)
                            let jsonString = String(data: jsonData, encoding: .utf8)!
                                                        
                            addJsonToFile(fileName: "currentHabitData.json", jsonString: jsonString)
                            viewModel.loadJsonData()
                            
                            numOfEggs = getItemCount(fileName: "currentHabitData.json")
                            
                            self.presentationMode.wrappedValue.dismiss()
                        } catch {
                            print("Error encoding habit: \(error)")
                        }
                        
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    Text("Start Hatching!").font(Font.custom("Inika-Bold", size: 18))
                        .foregroundColor(.black)
                })
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color(red: 1.0, green: 0.682, blue: 0.682))
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black, lineWidth: 1))
            }
        }
    }
}

struct AddEggViewPreview: PreviewProvider {
    static var previews: some View {
        @State var numOfEggs = 0
        
        AddEggView(viewModel: HabitViewModel(), numOfEggs: $numOfEggs)
    }
}
