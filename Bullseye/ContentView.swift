//
//  ContentView.swift
//  Bullseye
//
//  Created by Владимир Дельгадильо on 31.03.2020.
//  Copyright © 2020 Владимир Дельгадильо. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let midnightBlue = Color(red: 0, green: 0.2, blue: 0.4)
    
    @State var alertIsVisible = false
    @State var sliderValue = 50.0
    @State var target = Int.random(in: 0...100)
    @State var score = 0
    @State var round = 1
    
    let MAX_SCORE = 100
    
    var sliderValueRounded: Int {
        Int(sliderValue)
    }
    
    func countRoundScore() -> Int {
        let difference = abs(sliderValueRounded - target)
        let points: Int
        
        switch difference {
        case 0:
            points = 200
        case 1:
            points = 150
        default:
            points = MAX_SCORE - difference
        }
        
        return points
    }
    
    func popUpMessageText() -> String {
        return "The slider's value is \(sliderValueRounded).\n" + "The target value is \(target).\n" + "You scored \(countRoundScore()) points this round."
    }
    
    func titleGenerator() -> String {
        switch countRoundScore() {
        case 200:
            return "Perfect!"
        case 95...150:
            return "You almost had it!"
        case 90...94:
            return "Not bad."
        default:
            return "Are you even trying?"
        }
    }
    
    func setInitialState() {
        score = 0
        target = Int.random(in: 0...100)
        round = 1
        sliderValue = Double.random(in: 0...100)
    }
    
    func setNewRound() {
        score += countRoundScore()
        target = Int.random(in: 0...100)
        round += 1
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer().navigationBarTitle("🎯 Bullseye 🎯")
                HStack {
                    Text("Put the bullseye as close as you can to:").modifier(LabelStyle())
                    Text(String(target)).modifier(ValueStyle())
                }
                Spacer()
                HStack {
                    Text("0").modifier(LabelStyle())
                    Slider(value: $sliderValue, in: 0...100)
                        .accentColor(Color.green)
                        .animation(.easeOut)
                    Text("100").modifier(LabelStyle())
                }
                Spacer()
                Button(action: {
                        self.alertIsVisible = true
                    }) {
                        Text("Hit me!").modifier(ButtonLargeTextStyle())
                }
                .background(Image("Button").modifier(Shadow()))
                    .alert(isPresented: $alertIsVisible) {
                    Alert(title: Text(titleGenerator()), message: Text(popUpMessageText()), dismissButton: .default(Text("Awesome"), action: setNewRound))
                    
                }
                Spacer()
                HStack {
                    Button(action: setInitialState) {
                        HStack {
                            Image("StartOverIcon")
                            Text("Start over").modifier(ButtonSmallTextStyle())
                        }
                    }
                    .background(Image("Button").modifier(Shadow()))
                    Spacer()
                    HStack {
                        Text("Score:").modifier(LabelStyle())
                        Text(String(score)).modifier(ValueStyle())
                    }
                    Spacer()
                    HStack {
                        Text("Round").modifier(LabelStyle())
                        Text(String(round)).modifier(ValueStyle())
                    }
                    Spacer()
                    NavigationLink(destination: AboutView()) {
                        HStack {
                            Image("InfoIcon")
                            Text("Info").modifier(ButtonSmallTextStyle())
                        }
                    }
                    .background(Image("Button").modifier(Shadow()))
                }
                .padding(.bottom, 20)
                .accentColor(midnightBlue)
            }
            .onAppear(perform: setInitialState)
            .background(Image("Background"))
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct LabelStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Rounded MT Bold", size: 18))
            .foregroundColor(Color.white)
            .modifier(Shadow())
    }
}

struct ValueStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Rounded MT Bold", size: 24))
            .foregroundColor(Color.yellow)
            .modifier(Shadow())
        
    }
}

struct Shadow: ViewModifier {
    func body(content: Content) -> some View {
        content.shadow(color: Color.black, radius: 5, x: 2, y: 2)
    }
}

struct ButtonSmallTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Rounded MT Bold", size: 12))
            .foregroundColor(Color.black)
        
    }
}

struct ButtonLargeTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Rounded MT Bold", size: 18))
            .foregroundColor(Color.black)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
