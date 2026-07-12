import Foundation
import ImageIO
import UIKit
import UniformTypeIdentifiers

enum Spatial3DSpatialPhotoWriter {
    static func writeSpatialPhoto(left: UIImage, right: UIImage, to url: URL) throws {
        guard let leftData = left.jpegData(compressionQuality: 0.95),
              let rightData = right.jpegData(compressionQuality: 0.95),
              let leftSource = CGImageSourceCreateWithData(leftData as CFData, nil),
              let rightSource = CGImageSourceCreateWithData(rightData as CFData, nil),
              let leftImage = CGImageSourceCreateImageAtIndex(leftSource, 0, nil),
              let rightImage = CGImageSourceCreateImageAtIndex(rightSource, 0, nil) else {
            throw Spatial3DConversionError.exportFailed("Could not prepare stereo images.")
        }

        guard let destination = CGImageDestinationCreateWithURL(
            url as CFURL,
            UTType.heic.identifier as CFString,
            2,
            nil
        ) else {
            throw Spatial3DConversionError.exportFailed("Could not create HEIC destination.")
        }

        let leftProperties: [CFString: Any] = [
            kCGImagePropertyGroups: [
                kCGImagePropertyGroupType: "StereoPair",
                kCGImagePropertyGroupImageIsLeftImage: true
            ]
        ]

        let rightProperties: [CFString: Any] = [
            kCGImagePropertyGroups: [
                kCGImagePropertyGroupType: "StereoPair",
                kCGImagePropertyGroupImageIsRightImage: true
            ]
        ]

        CGImageDestinationAddImage(destination, leftImage, leftProperties as CFDictionary)
        CGImageDestinationAddImage(destination, rightImage, rightProperties as CFDictionary)

        guard CGImageDestinationFinalize(destination) else {
            throw Spatial3DConversionError.exportFailed("Could not finalize spatial HEIC.")
        }
    }
}
