import AVFoundation
import Foundation

final class Spatial3DFrameDecoder {
    private let asset: AVAsset

    init(url: URL) {
        self.asset = AVAsset(url: url)
    }

    func loadTracks() async throws -> (videoTrack: AVAssetTrack, duration: CMTime, nominalFrameRate: Float) {
        let tracks = try await asset.loadTracks(withMediaType: .video)
        guard let track = tracks.first else {
            throw Spatial3DConversionError.invalidInput
        }
        let duration = try await asset.load(.duration)
        let frameRate = try await track.load(.nominalFrameRate)
        return (track, duration, frameRate)
    }
}
