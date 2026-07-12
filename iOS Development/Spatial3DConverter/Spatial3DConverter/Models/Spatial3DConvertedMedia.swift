import Foundation

enum Spatial3DMediaType: String, Codable, CaseIterable {
    case photo
    case video
}

enum Spatial3DOutputFormat: String, Codable, CaseIterable, Identifiable {
    case spatialPhoto
    case spatialVideo
    case sbsVR
    case topBottomVR

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .spatialPhoto: return "Spatial Photo"
        case .spatialVideo: return "Spatial Video"
        case .sbsVR: return "SBS VR"
        case .topBottomVR: return "Top-Bottom VR"
        }
    }
}

enum Spatial3DEngineMode: String, Codable, CaseIterable, Identifiable {
    case turbo
    case quality

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .turbo: return "Turbo"
        case .quality: return "Best Quality"
        }
    }
}

enum Spatial3DPreviewMode: String, CaseIterable, Identifiable {
    case wiggle
    case crossEye
    case parallel
    case sbs

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .wiggle: return "Wiggle"
        case .crossEye: return "Cross-Eye"
        case .parallel: return "Parallel"
        case .sbs: return "Side-by-Side"
        }
    }
}

enum Spatial3DConversionStatus: String, Codable {
    case queued
    case converting
    case complete
    case failed
}

struct Spatial3DConvertedMedia: Identifiable, Codable, Hashable {
    let id: UUID
    var type: Spatial3DMediaType
    var createdAt: Date
    var filePath: String
    var thumbnailPath: String?
    var strength: Double
    var outputFormat: Spatial3DOutputFormat
    var engineMode: Spatial3DEngineMode
    var status: Spatial3DConversionStatus

    init(
        id: UUID = UUID(),
        type: Spatial3DMediaType,
        createdAt: Date = .now,
        filePath: String,
        thumbnailPath: String? = nil,
        strength: Double = 0.5,
        outputFormat: Spatial3DOutputFormat = .spatialPhoto,
        engineMode: Spatial3DEngineMode = .turbo,
        status: Spatial3DConversionStatus = .queued
    ) {
        self.id = id
        self.type = type
        self.createdAt = createdAt
        self.filePath = filePath
        self.thumbnailPath = thumbnailPath
        self.strength = strength
        self.outputFormat = outputFormat
        self.engineMode = engineMode
        self.status = status
    }
}

struct Spatial3DConversionSettings: Equatable {
    var strength: Double = 0.5
    var outputFormat: Spatial3DOutputFormat = .spatialPhoto
    var engineMode: Spatial3DEngineMode = .turbo
    var previewMode: Spatial3DPreviewMode = .sbs
}

struct Spatial3DConversionProgress: Equatable {
    var fractionComplete: Double
    var processedFrames: Int
    var totalFrames: Int
    var elapsedSeconds: TimeInterval
    var estimatedRemainingSeconds: TimeInterval?

    static let zero = Spatial3DConversionProgress(
        fractionComplete: 0,
        processedFrames: 0,
        totalFrames: 0,
        elapsedSeconds: 0,
        estimatedRemainingSeconds: nil
    )
}

enum Spatial3DConversionError: LocalizedError {
    case modelNotLoaded
    case invalidInput
    case exportFailed(String)
    case pipelineCancelled

    var errorDescription: String? {
        switch self {
        case .modelNotLoaded:
            return "Spatial3D depth model is not loaded. Relaunch the app and try again."
        case .invalidInput:
            return "The selected media could not be processed."
        case .exportFailed(let reason):
            return "Export failed: \(reason)"
        case .pipelineCancelled:
            return "Conversion was cancelled."
        }
    }
}
