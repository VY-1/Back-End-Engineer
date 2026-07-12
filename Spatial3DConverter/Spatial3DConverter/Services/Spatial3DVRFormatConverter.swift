import Foundation

/// Bidirectional VR ↔ Spatial format conversion without re-inference.
enum Spatial3DVRFormatConverter {
    enum InputLayout {
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
}
