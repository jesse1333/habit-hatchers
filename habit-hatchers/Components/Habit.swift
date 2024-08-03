//
//  Habit.swift
//  habit-hatchers
//
//  Created by Jesse Tzo on 7/2/24.
//

import Foundation
import SwiftUI
import SwiftData

struct Habit : Identifiable, Codable {
    var id = UUID()
    var habitName: String
    var isDisplayed = true
    var habitType: String
    var totalCollected: Int
    var streak: Int
    var daysKept: Int
    var startDate: String
    var endDate: String
}

