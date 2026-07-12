import CoreGraphics
import Foundation
import ImageIO
import UIKit
import UniformTypeIdentifiers

enum Spatial3DVRFormatConverter {
    enum InputLayout: String {
        case sideBySide
        case halfSideBySide
        case topBottom
        case spatial
        case mono2D
    }

    static func detectLayout(from url: URL) -> InputLayout {
        let name = url.lastPathComponent.lowercased()
        if name.contains("tb") || name.contains("topbottom") { return .topBottom }
        if name.contains("hsbs") || name.contains("half") { return .halfSideBySide }
        if name.contains("sbs") { return .sideBySide }
        if url.pathExtension.lowercased() == "heic" { return .spatial }
        return .mono2D
    }

    static func splitSideBySide(_ image: UIImage) -> (left: UIImage, right: UIImage)? {
        guard let cg = image.cgImage else { return nil }
        let width = cg.width / 2
        let height = cg.height
        guard let leftCG = cg.cropping(to: CGRect(x: 0, y: 0, width: width, height: height)),
              let rightCG = cg.cropping(to: CGRect(x: width, y: 0, width: width, height: height)) else {
            return nil
        }
        return (UIImage(cgImage: leftCG), UIImage(cgImage: rightCG))
    }

    static func splitTopBottom(_ image: UIImage) -> (left: UIImage, right: UIImage)? {
        guard let cg = image.cgImage else { return nil }
        let width = cg.width
        let height = cg.height / 2
        guard let topCG = cg.cropping(to: CGRect(x: 0, y: 0, width: width, height: height)),
              let bottomCG = cg.cropping(to: CGRect(x: 0, y: height, width: width, height: height)) else {
            return nil
        }
        return (UIImage(cgImage: topCG), UIImage(cgImage: bottomCG))
    }

    static func convertVRImageToSpatial(_ image: UIImage, layout: InputLayout, outputURL: URL) throws {
        let pair: (UIImage, UIImage)?
        switch layout {
        case .sideBySide, .halfSideBySide:
            pair = splitSideBySide(image)
        case .topBottom:
            pair = splitTopBottom(image)
        case .spatial, .mono2D:
            pair = nil
        }
        guard let (left, right) = pair else {
            throw Spatial3DConversionError.invalidInput
        }
        try Spatial3DSpatialPhotoWriter.writeSpatialPhoto(left: left, right: right, to: outputURL)
    }

    static func convertSpatialImageToSBS(_ image: UIImage) throws -> UIImage {
        if let pair = splitSideBySide(image) {
            return pair.left // Already SBS
        }
        throw Spatial3DConversionError.invalidInput
    }

    static func loadSpatialPair(from url: URL) throws -> (UIImage, UIImage) {
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil),
              CGImageSourceGetCount(source) >= 2,
              let left = CGImageSourceCreateImageAtIndex(source, 0, nil),
              let right = CGImageSourceCreateImageAtIndex(source, 1, nil) else {
            throw Spatial3DConversionError.invalidInput
        }
        return (UIImage(cgImage: left), UIImage(cgImage: right))
    }

    static func writeSBS(left: UIImage, right: UIImage) -> UIImage? {
        guard let leftCI = CIImage(image: left), let rightCI = CIImage(image: right) else { return nil }
        let sbs = Spatial3DSBSEncoder.encode(left: leftCI, right: rightCI, layout: .sbsVR)
        return Spatial3DImageUtilities.uiImage(from: sbs)
    }
}
