import SwiftUI

struct Spatial3DHomeView: View {
    var body: some View {
        List {
            Section("Convert") {
                NavigationLink {
                    Spatial3DConvertView(mediaKind: .photo)
                } label: {
                    Label("Convert Photo", systemImage: "photo.on.rectangle.angled")
                }
                NavigationLink {
                    Spatial3DConvertView(mediaKind: .video)
                } label: {
                    Label("Convert Video", systemImage: "video")
                }
            }

            Section("Library") {
                NavigationLink {
                    Spatial3DGalleryView()
                } label: {
                    Label("Spatial Gallery", systemImage: "square.grid.2x2")
                }
                NavigationLink {
                    Spatial3DBatchQueueView()
                } label: {
                    Label("Batch Queue", systemImage: "tray.full")
                }
                NavigationLink {
                    Spatial3DFormatConvertView()
                } label: {
                    Label("VR ↔ Spatial Convert", systemImage: "arrow.triangle.2.circlepath")
                }
            }

            Section("About") {
                Text("Spatial3D Converter turns 2D photos and videos into Spatial, SBS, and VR formats using on-device AI optimized for iOS 26+.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Spatial3D Converter")
    }
}
