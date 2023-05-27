//
//  ContentView.swift
//  CobaWatchOs Watch App
//
//  Created by David Mahbubi on 28/05/23.
//

import SwiftUI
import Foundation

struct ContentView: View {
    
    @State private var imageName: String = ""
    @State private var buttonName: String = "Roll"
    @State private var number: UInt8 = 0
    @State private var timer: Timer?
    @State private var selectedTab: UInt8 = 0
    @State private var rollingTime: UInt8 = 2
    
    var body: some View {
        TabView(selection: $selectedTab) {
            VStack {
                Image(number == 0 ? "main_logo" : imageName)
                    .padding(.bottom, 30)
                    .padding(.top, 30)
                Spacer()
                Button(buttonName) {
                    buttonName = "Rolling..."
                    randomizeDice()
                }
                .buttonStyle(BorderedButtonStyle(tint: .red))
            }
            .tabItem {
                Label("Tab 1", systemImage: "1.circle")
            }
            .tag(0)
            Form {
                Section(header: Text("Rolling Time")) {
                    Stepper(value: $rollingTime, in: 1...10) {
                        Text("\(rollingTime) second")
                            .font(.system(size: 15))
                    }
                }
                Section(header: Text("Rolling Speed")) {
                    Stepper(value: $rollingTime, in: 1...10) {
                        Text("\(rollingTime) ms")
                            .font(.system(size: 15))
                    }
                }
            }
            .tabItem {
                Label("Tab 2", systemImage: "2.circle")
            }
        }
    }
    
    func randomizeDice() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            number = UInt8(arc4random_uniform(6) + 1)
            imageName = "Dice \(number)"
        }
        DispatchQueue.main.asyncAfter(deadline: (.now() + .seconds(Int(rollingTime))), execute: onRandomizeCompleted)
    }
    
    func onRandomizeCompleted() {
        self.timer?.invalidate()
        self.timer = nil
        self.buttonName = "Roll"
        WKInterfaceDevice.current().play(.notification)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
