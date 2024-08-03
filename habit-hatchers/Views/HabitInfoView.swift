//
//  HabitInfoView.swift
//  habit-hatchers
//
//  Created by Jesse Tzo on 7/9/24.
//

import Foundation
import SwiftUI

struct HabitInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var inputHabit: String = ""
    @ObservedObject var viewModel : HabitViewModel
    @State private var showConfirmation: Bool = false
    @Binding var numOfEggs : Int
    @Binding var displayHabit : String
    
    var settingsEggType : String
    @Binding var habitNameString : String
    @Binding var showHabitInfoView : Bool
    @Binding var habitIDString : String
    @Binding var habitType : String
    @Binding var totalCollected : Int
    @Binding var currentStreak : Int
    @Binding var activeDays : Int
    @Binding var started : String
    @Binding var ended : String
    
    @State var confirmTitle = ""
    @State var confirmMessage = ""
    @State var confirmButtonText = ""
    @State var restoreHabit = false
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9137254902, alpha: 1)).ignoresSafeArea()
            
            // Egg Stats
            VStack {
                Text("Egg Stats:").font(Font.custom("Inika-Bold", size: 30)).offset(y: 60)
                
                // Egg Image
                Image("egg_uncracked")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                // Lower Component
                VStack {
                    // Habit Name
                    Button(action: {
                        print("Habit Name Clicked")
                    }, label: {
                        Text(habitNameString).font(Font.custom("Inika-Bold", size: 25))
                            .foregroundColor(.black)
                    })
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color(red: 1.0, green: 1.0, blue: 1.0))
                    .cornerRadius(30)
                    .overlay(RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.black, lineWidth: 1))
                    
                    // Egg Info
                    VStack(alignment: .leading,
                           spacing: 5,
                           content: {
                        
                        Text("Total Collected: " + String(totalCollected) + " Eggs").font(Font.custom("Inika-Bold", size: 20))
                        
                        if settingsEggType == "current" {
                            Text("Current Streak: " + String(currentStreak) + " Days").font(Font.custom("Inika-Bold", size: 20))
                        }
                        else if settingsEggType == "past" {
                            Text("Active Days: " + String(activeDays) + " Days").font(Font.custom("Inika-Bold", size: 20))
                        }
                        
                        Text("Started: " + started).font(Font.custom("Inika-Bold", size: 20))
                        
                        Text("Ended: " + ended).font(Font.custom("Inika-Bold", size: 20))
                        
                    }).offset(y: 20)
                }.offset(y: 20)
                
            }.offset(y: -45)
            
            // Remove Egg Button
            Button(action: {
                print("Remove Egg Clicked")
                showConfirmation = true
                
                if settingsEggType == "current" {
                    confirmTitle = "Are you sure?"
                    confirmMessage = "Deleted habits will be stored"
                    confirmButtonText = "I am sure"
                }
                
                else if settingsEggType == "past" {
                    confirmTitle = "Deleting past habits will be permanent."
                    confirmMessage = "Do you wish to proceed?"
                    confirmButtonText = "I am sure"
                }
                
            }, label: {
                Text("X").font(Font.custom("Inika-Bold", size: 25))
                    .foregroundColor(.black)
            })
            .padding(.horizontal, 10)
            .padding(.vertical, 3)
            .background(Color(red: 1.0, green: 0.682, blue: 0.682))
            .cornerRadius(30)
            .overlay(RoundedRectangle(cornerRadius: 50)
                .stroke(Color.black, lineWidth: 1))
            .position(x: 330, y: 160)
            
            // restore egg button
            if (settingsEggType == "past") {
                Button(action: {
                    print("Restore Egg Clicked")
                    showConfirmation = true
                    confirmTitle = "Restore Egg!"
                    confirmMessage = "Would you like to restore this egg?"
                    confirmButtonText = "Restore Egg"
                    restoreHabit = true
                    
                }, label: {
                    Image("restore")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25)
                    
                })
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
                .background(Color(red: 0.722, green: 0.969, blue: 0.698))
                .cornerRadius(30)
                .overlay(RoundedRectangle(cornerRadius: 50)
                    .stroke(Color.black, lineWidth: 1))
                .position(x: 330, y: 215)
            }
            
            
            if showConfirmation {
                if settingsEggType == "current" {
                    EggDeletionConfirmationView(showConfirmation: $showConfirmation, habitIDString: $habitIDString, showHabitInfoView: $showHabitInfoView, displayHabit: $displayHabit, viewModel: viewModel, title: confirmTitle, message: confirmMessage, buttonTitle: confirmButtonText) {
                        deleteJsonData(habitID: habitIDString, currentFile: "currentHabitData.json", pastFile: "pastHabitData.json")
                        numOfEggs = getItemCount(fileName: "currentHabitData.json")
                    }
                }
                else if settingsEggType == "past" {
                    EggDeletionConfirmationView(showConfirmation: $showConfirmation, habitIDString: $habitIDString, showHabitInfoView: $showHabitInfoView, displayHabit: $displayHabit, viewModel: viewModel, title: confirmTitle, message: confirmMessage, buttonTitle: confirmButtonText) {
                        
                        if restoreHabit {
                            restoreJsonData(habitID: habitIDString, currentFile: "currentHabitData.json", pastFile: "pastHabitData.json")
                        }
                        else {
                            deleteJsonData(habitID: habitIDString, fileName: "pastHabitData.json")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    struct BindingViewPreviewContainer : View {
        @State private var numOfEggs = 0
        @State private var displayHabit = " "
        @State private var habitNameString = "Test"
        @State private var showHabitInfoView = false
        @State private var habitIDString = ""
        @State private var habitType = ""
        @State private var totalCollected = 0
        @State private var currentStreak = 0
        @State private var activeDays = 0
        @State private var started = "01-11-2010"
        @State private var ended = "---"
        
        var body: some View {
            HabitInfoView(viewModel: HabitViewModel(), numOfEggs: $numOfEggs, displayHabit: $displayHabit, settingsEggType: "past", habitNameString: $habitNameString, showHabitInfoView: $showHabitInfoView,  habitIDString: $habitIDString,
                          habitType: $habitType,
                          totalCollected: $totalCollected,
                          currentStreak : $currentStreak,
                          activeDays: $activeDays, started : $started,
                          ended: $ended)
        }
    }
    
    return BindingViewPreviewContainer()
}
