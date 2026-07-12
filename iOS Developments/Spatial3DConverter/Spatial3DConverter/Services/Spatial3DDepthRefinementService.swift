import CoreImage
import Foundation

enum Spatial3DDepthRefinementService {
    static func refine(_ depth: CIImage, previous: CIImage?, smoothing: Double = 0.7) -> CIImage {
        var refined = depth

        if let blur = CIFilter(name: "CIGaussianBlur") {
            blur.setValue(refined, forKey: kCIInputImageKey)
            blur.setValue(1.2, forKey: kCIInputRadiusKey)
            if let blurred = blur.outputImage?.cropped(to: depth.extent) {
                refined = blurred
            }
        }

        if let previous {
            refined = blend(current: refined, previous: previous, alpha: smoothing)
        }

        return refined
    }

    private static func blend(current: CIImage, previous: CIImage, alpha: Double) -> CIImage {
        guard let filter = CIFilter(name: "CISourceOverCompositing") else { return current }
        let scaledPrevious = previous.applyingFilter("CIColorMatrix", parameters: [
            "inputAVector": CIVector(x: 0, y: 0, z: 0, w: alpha)
        ])
        filter.setValue(current, forKey: kCIInputImageKey)
        filter.setValue(scaledPrevious, forKey: kCIInputBackgroundImageKey)
        return filter.outputImage?.cropped(to: current.extent) ?? current
    }
}
