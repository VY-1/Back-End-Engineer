import CoreImage
import Foundation

final class Spatial3DTemporalDepthSmoother {
    private var previousDepth: CIImage?
    private let alpha: Double

    init(alpha: Double = 0.7) {
        self.alpha = alpha
    }

    func smooth(_ depth: CIImage) -> CIImage {
        let output = Spatial3DDepthRefinementService.refine(depth, previous: previousDepth, smoothing: alpha)
        previousDepth = output
        return output
    }

    func reset() {
        previousDepth = nil
    }
}
