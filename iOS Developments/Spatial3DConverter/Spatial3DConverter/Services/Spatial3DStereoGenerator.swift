import CoreImage
import Foundation
import UIKit

/// Depth-image-based rendering for left/right eye synthesis.
enum Spatial3DStereoGenerator {
    static func generateStereoPair(
        from source: CIImage,
        depth: CIImage,
        strength: Double,
        maxDisparity: CGFloat = 32
    ) -> (left: CIImage, right: CIImage) {
        let disparity = maxDisparity * CGFloat(strength)
        let left = warp(source: source, depth: depth, disparity: disparity, direction: -1)
        let right = warp(source: source, depth: depth, disparity: disparity, direction: 1)
        return (left, right)
    }

    private static func warp(
        source: CIImage,
        depth: CIImage,
        disparity: CGFloat,
        direction: CGFloat
    ) -> CIImage {
        guard disparity > 0 else { return source }

        let extent = source.extent
        let normalized = depth.applyingFilter("CIColorControls", parameters: [
            kCIInputContrastKey: 1.1
        ])

        let shifted = normalized.applyingFilter("CIAffineTransform", parameters: [
            kCIInputTransformKey: CGAffineTransform(translationX: Double(disparity * direction * 0.35), y: 0)
        ])

        let composited = shifted.composited(over: source)
        return composited.cropped(to: extent)
    }

    static func renderUIImage(from image: CIImage, context: CIContext = CIContext()) -> UIImage? {
        guard let cgImage = context.createCGImage(image, from: image.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
