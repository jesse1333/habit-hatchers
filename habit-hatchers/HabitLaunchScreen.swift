import SwiftUI

struct SwiftUIView: View {
    @State private var inputHabit: String = ""
    @State private var habitOne: String = ""
    @State private var habitTwo: String = ""
    @State private var habitThree: String = ""
    @State private var screenState: Int = 1
    @State private var switchScreen: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(#colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9137254902, alpha: 1)).ignoresSafeArea()
                
                VStack {
                    if screenState == 1 {
                        VStack {
                            Text("Enter habit #1:")
                                .font(Font.custom("Inika-Bold", size: 28))
                                .multilineTextAlignment(.center)
                            
                            HStack {
                                TextField("Please enter a habit", text: $inputHabit)
                                    .font(Font.custom("Inika", size: 14))
                                    .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                                    .frame(width: 200)
                                
                                Button(action: {
                                    if !inputHabit.isEmpty {
                                        habitOne = inputHabit
                                        inputHabit = ""
                                        screenState = 2
                                        print("Habit One: " + habitOne)
                                    }
                                }) {
                                    Image("next-icon")
                                        .resizable()
                                        .background(Color.clear)
                                        .frame(width: 25, height: 25)
                                }
                            }
                        }
                    }
                    
                    else if screenState == 2 {
                        
                        VStack {
                            Text("Enter habit #2:")
                                .font(Font.custom("Inika-Bold", size: 28))
                                .multilineTextAlignment(.center)
                            
                            HStack {
                                TextField("Please enter a habit", text: $inputHabit)
                                    .font(Font.custom("Inika", size: 14))
                                    .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                                    .frame(width: 200)
                                
                                Button(action: {
                                    if !inputHabit.isEmpty {
                                        habitTwo = inputHabit
                                        inputHabit = ""
                                        screenState = 3
                                        print("Habit Two: " + habitTwo)
                                    }
                                }) {
                                    Image("next-icon")
                                        .resizable()
                                        .background(Color.clear)
                                        .frame(width: 25, height: 25)
                                }
                            }
                        }
                    }
                    
                    else if screenState == 3 {
                        VStack {
                            Text("Enter habit #3:")
                                .font(Font.custom("Inika-Bold", size: 28))
                                .multilineTextAlignment(.center)
                            
                            HStack {
                                TextField("Please enter a habit", text: $inputHabit)
                                    .font(Font.custom("Inika", size: 14))
                                    .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                                    .frame(width: 200)
                                
                                
                                NavigationLink(destination: {
                                    ContentView()
                                    
                                    
                                }, label: {
                                    
                                    Image("next-icon")
                                        .resizable()
                                        .background(Color.clear)
                                        .frame(width: 25, height: 25)
                                    
                                })
                                .simultaneousGesture(TapGesture().onEnded {
                                    print("Navigating")
                                    habitThree = inputHabit
                                    inputHabit = ""
                                })
                            }
                        }
                    }
                }
            }
        }.navigationBarHidden(true)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
