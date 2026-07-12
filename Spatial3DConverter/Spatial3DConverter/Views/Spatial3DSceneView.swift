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
        }
        .navigationTitle("Live Preview")
    }
}

struct Spatial3DBatchQueueView: View {
    @StateObject private var queue = Spatial3DBatchConversionQueue()

    var body: some View {
        List {
            if queue.queue.isEmpty {
                ContentUnavailableView("Empty Queue", systemImage: "tray", description: Text("Add photos or videos to batch convert."))
            } else {
                ForEach(queue.queue) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.type.rawValue.capitalized)
                            Text(item.status.rawValue.capitalized)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Batch Queue")
    }
}
