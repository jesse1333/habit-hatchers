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
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9137254902, alpha: 1)).ignoresSafeArea()
            
            VStack {
                
                Text("Add a Habit!").font(Font.custom("Inika-Bold", size: 35))
                
                Image("egg_uncracked")
                    .resizable()
                    .frame(width: 220, height: 220)
                
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
                
                Button(action: {
                    print("Egg Submitted")
                    
                    if inputHabit != "" {
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

#Preview {
    AddEggView()
}
