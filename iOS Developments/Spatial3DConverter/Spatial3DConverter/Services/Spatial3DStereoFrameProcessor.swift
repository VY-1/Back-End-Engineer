import CoreImage
import CoreVideo
import Foundation
import UIKit

/// Shared stereo synthesis used by photo and video pipelines.
enum Spatial3DStereoFrameProcessor {
    static func process(
        source: CIImage,
        depth: CIImage,
        settings: Spatial3DConversionSettings,
        previousDepth: CIImage? = nil
    ) -> (left: CIImage, right: CIImage, refinedDepth: CIImage, sbs: CIImage) {
        let refined = Spatial3DDepthRefinementService.refine(depth, previous: previousDepth)
        let pair = Spatial3DStereoGenerator.generateStereoPair(
            from: source,
            depth: refined,
            strength: settings.strength
        )
        let layout: Spatial3DOutputFormat = settings.outputFormat == .topBottomVR ? .topBottomVR : .sbsVR
        let sbs = Spatial3DSBSEncoder.encode(left: pair.left, right: pair.right, layout: layout)
        return (pair.left, pair.right, refined, sbs)
    }

    static func processUIImage(_ image: UIImage, depth: CIImage, settings: Spatial3DConversionSettings) -> UIImage? {
        guard let source = CIImage(image: image) else { return nil }
        let result = process(source: source, depth: depth, settings: settings)
        return Spatial3DImageUtilities.uiImage(from: result.sbs)
    }
}
