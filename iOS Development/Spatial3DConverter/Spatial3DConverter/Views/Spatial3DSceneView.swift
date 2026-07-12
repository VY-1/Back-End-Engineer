import SwiftUI

struct Spatial3DSceneView: View {
    let images: [UIImage]

    var body: some View {
        TabView {
            ForEach(Array(images.enumerated()), id: \.offset) { _, image in
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding()
            }
        }
        .tabViewStyle(.page)
        .navigationTitle("Spatial Scenes")
    }
}

struct Spatial3DRealTimePreviewPlayer: View {
    @StateObject private var pipeline = Spatial3DRealTimePreviewPipeline()
    let videoURL: URL?

    var body: some View {
        VStack(spacing: 12) {
            ContentUnavailableView(
                "Spatial Preview",
                systemImage: "play.rectangle",
                description: Text("Live spatial preview runs on device without exporting.")
            )
            if pipeline.isPreviewing {
                ProgressView("Previewing…")
            }
            if let videoURL {
                Button("Start Preview") {
                    Task { await pipeline.startPreview(for: videoURL) }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .navigationTitle("Live Preview")
        .onDisappear { pipeline.stopPreview() }
    }
}
