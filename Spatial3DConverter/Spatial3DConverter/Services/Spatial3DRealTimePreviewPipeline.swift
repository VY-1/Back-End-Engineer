import Foundation

@MainActor
final class Spatial3DRealTimePreviewPipeline: ObservableObject {
    @Published private(set) var isPreviewing = false

    func startPreview(for url: URL) async {
        isPreviewing = true
        defer { isPreviewing = false }
        try? await Task.sleep(nanoseconds: 500_000_000)
    }

    func stopPreview() {
        isPreviewing = false
    }
}
