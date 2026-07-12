import Foundation

enum Spatial3DPerformanceMonitor {
    static var thermalState: ProcessInfo.ThermalState {
        ProcessInfo.processInfo.thermalState
    }

    static var shouldReduceQuality: Bool {
        switch thermalState {
        case .serious, .critical:
            return true
        default:
            return false
        }
    }

    static var recommendedEngineMode: Spatial3DEngineMode {
        shouldReduceQuality ? .turbo : .quality
    }
}
