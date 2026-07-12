import SwiftUI

struct Spatial3DHomeView: View {
    var onConvertPhoto: () -> Void
    var onConvertVideo: () -> Void
    var onOpenGallery: () -> Void
    var onOpenBatch: () -> Void

    var body: some View {
        NavigationStack {
            List {
                Section("Convert") {
                    Button(action: onConvertPhoto) {
                        Label("Convert Photo", systemImage: "photo.on.rectangle.angled")
                    }
                    Button(action: onConvertVideo) {
                        Label("Convert Video", systemImage: "video")
                    }
                }

                Section("Library") {
                    Button(action: onOpenGallery) {
                        Label("Spatial Gallery", systemImage: "square.grid.2x2")
                    }
                    Button(action: onOpenBatch) {
                        Label("Batch Queue", systemImage: "tray.full")
                    }
                }

                Section("About") {
                    Text("Spatial3D Converter turns 2D photos and videos into Spatial, SBS, and VR formats using on-device AI.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Spatial3D Converter")
        }
    }
}
