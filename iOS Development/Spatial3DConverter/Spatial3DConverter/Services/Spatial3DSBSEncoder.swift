import CoreImage
import Foundation
import UIKit

enum Spatial3DSBSEncoder {
    static func encode(left: CIImage, right: CIImage, layout: Spatial3DOutputFormat) -> CIImage {
        switch layout {
        case .topBottomVR:
            return stackTopBottom(left: left, right: right)
        default:
            return stackSideBySide(left: left, right: right)
        }
    }

    static func encode(image: UIImage, left: CIImage, right: CIImage, layout: Spatial3DOutputFormat) -> UIImage? {
        guard let source = CIImage(image: image) else { return nil }
        let extent = source.extent
        let leftCropped = left.cropped(to: extent)
        let rightCropped = right.cropped(to: extent)
        let output = encode(left: leftCropped, right: rightCropped, layout: layout)
        return Spatial3DStereoGenerator.renderUIImage(from: output)
    }

    private static func stackSideBySide(left: CIImage, right: CIImage) -> CIImage {
        let extent = left.extent
        let translatedRight = right.transformed(by: CGAffineTransform(translationX: extent.width, y: 0))
        return translatedRight.composited(over: left)
    }

    private static func stackTopBottom(left: CIImage, right: CIImage) -> CIImage {
        let extent = left.extent
        let translatedRight = right.transformed(by: CGAffineTransform(translationX: 0, y: extent.height))
        return translatedRight.composited(over: left)
    }
}
