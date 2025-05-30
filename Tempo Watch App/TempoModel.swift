import Foundation
import SwiftUI
import WatchKit

enum TempoPhase: Int, CaseIterable {
    case firstCount = 0
    case upCount
    case downCount
    case lastCount
    
    var duration: Int {
        switch self {
        case .firstCount: return 1
        case .upCount: return 4
        case .downCount: return 2
        case .lastCount: return 1
        }
    }
    
    var color: Color {
        switch self {
        case .firstCount: return .blue
        case .upCount: return .green
        case .downCount: return .orange
        case .lastCount: return .red
        }
    }
}

class TempoModel: ObservableObject {
    @Published var isRunning = false
    @Published var currentPhase: TempoPhase = .firstCount
    @Published var timeRemaining: Int = 1
    
    private var timer: Timer?
    
    var totalTime: Int {
        TempoPhase.allCases.reduce(0) { $0 + $1.duration }
    }
    
    func start() {
        isRunning = true
        currentPhase = .firstCount
        timeRemaining = currentPhase.duration
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
    
    func stop() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        currentPhase = .firstCount
        timeRemaining = currentPhase.duration
    }
    
    private func updateTimer() {
        timeRemaining -= 1
        
        if timeRemaining <= 0 {
            let nextPhaseIndex = (currentPhase.rawValue + 1) % TempoPhase.allCases.count
            currentPhase = TempoPhase(rawValue: nextPhaseIndex) ?? .firstCount
            timeRemaining = currentPhase.duration
            
            // Send subtle vibration feedback on phase change
            WKInterfaceDevice.current().play(.click)
        }
    }
} 