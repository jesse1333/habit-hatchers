//
//  EggDeletionConfirmationView.swift
//  habit-hatchers
//
//  Created by Jesse Tzo on 7/20/24.
//

import SwiftUI

struct EggDeletionConfirmationView: View {
    @Binding var showConfirmation: Bool
    @Binding var habitIDString : String
    @Binding var showHabitInfoView : Bool
    @Binding var displayHabit : String
    @ObservedObject var viewModel : HabitViewModel

    let title: String
    let message: String
    let buttonTitle: String
    let action: () -> ()
    @State private var offset: CGFloat = 1000

    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    close()
                }

            VStack {
                Text(title)
                    .font(.title2)
                    .bold()
                    .padding()

                Text(message)
                    .font(.body)

                Button {
                    action()
                    close()
                    showHabitInfoView = false
                    displayHabit = " "
                    viewModel.loadJsonData()
                    
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.red)

                        Text(buttonTitle)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                    }
                    .padding()
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(alignment: .topTrailing) {
                Button {
                    close()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .fontWeight(.medium)
                }
                .tint(.black)
                .padding()
            }
            .shadow(radius: 20)
            .padding(30)
            .offset(x: 0, y: offset)
            .onChange(of: showConfirmation, initial: true) {
                print(habitIDString)
                withAnimation(.spring()) {
                    offset = 0
                }
            }
        }
        .ignoresSafeArea()
    }

    func close() {
        withAnimation(.spring()) {
            offset = 1000
            showConfirmation = false
        }
    }
}

struct EggDeletionConfirmationView_Preview: PreviewProvider {
    static var previews: some View {
        @State var habitIDString = ""
        @State var showHabitInfoView = false
        @State var displayHabit = ""
        
        EggDeletionConfirmationView(showConfirmation: .constant(true), habitIDString: $habitIDString, showHabitInfoView: $showHabitInfoView, displayHabit: $displayHabit, viewModel: HabitViewModel(), title: "Are you sure?", message: "Deleted habits will be stored", buttonTitle: "I am sure", action: {})
    }
}
