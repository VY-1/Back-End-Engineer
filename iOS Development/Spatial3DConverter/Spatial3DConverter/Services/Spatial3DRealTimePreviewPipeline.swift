import AVFoundation
import Foundation

@MainActor
final class Spatial3DRealTimePreviewPipeline: ObservableObject {
    @Published private(set) var isPreviewing = false

    private var player: AVPlayer?

    func startPreview(for url: URL) async {
        stopPreview()
        isPreviewing = true
        player = AVPlayer(url: url)
        player?.play()
    }

    func stopPreview() {
        player?.pause()
        player = nil
        isPreviewing = false
    }
}
