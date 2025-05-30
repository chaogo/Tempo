//
//  ContentView.swift
//  Tempo Watch App
//
//  Created by Chao Tang on 2025/5/30.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var tempoModel = TempoModel()
    
    var body: some View {
        VStack(spacing: 20) {
            TempoRingView(model: tempoModel)
            
            Button(action: {
                if tempoModel.isRunning {
                    tempoModel.stop()
                } else {
                    tempoModel.start()
                }
            }) {
                Text(tempoModel.isRunning ? "Stop" : "Start")
                    .font(.system(.title2, design: .rounded))
                    .bold()
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .tint(tempoModel.isRunning ? .red : .green)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
