import SwiftUI

struct TempoRingView: View {
    @ObservedObject var model: TempoModel
    
    private let lineWidth: CGFloat = 20
    
    var body: some View {
        ZStack {
            // Background segments
            ForEach(TempoPhase.allCases, id: \.rawValue) { phase in
                Circle()
                    .trim(from: progressForPhase(phase.rawValue, isStart: true),
                          to: progressForPhase(phase.rawValue, isStart: false))
                    .stroke(phase.color.opacity(0.3), lineWidth: lineWidth)
            }
            
            // Active segment
            Circle()
                .trim(from: 0, 
                      to: 1 - (Double(model.timeRemaining) / Double(model.currentPhase.duration)))
                .rotation(.degrees(-90))
                .stroke(model.currentPhase.color, lineWidth: lineWidth)
                .opacity(model.isRunning ? 1 : 0)
            
            // Countdown text
            Text("\(model.timeRemaining)")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .monospacedDigit()
                .rotationEffect(.degrees(90))
        }
        .frame(width: 120, height: 120)
        .rotationEffect(.degrees(-90))
    }
    
    private func progressForPhase(_ phase: Int, isStart: Bool) -> Double {
        let totalDuration = Double(model.totalTime)
        var accumulated = 0.0
        
        for i in 0..<phase {
            if let tempoPhase = TempoPhase(rawValue: i) {
                accumulated += Double(tempoPhase.duration)
            }
        }
        
        if !isStart, let currentPhase = TempoPhase(rawValue: phase) {
            accumulated += Double(currentPhase.duration)
        }
        
        return accumulated / totalDuration
    }
} 