import SwiftUI

struct Spatial3DGalleryView: View {
    @EnvironmentObject private var galleryStore: Spatial3DGalleryStore
    @EnvironmentObject private var webShareServer: Spatial3DWebShareServer

    @State private var sceneImages: [UIImage] = []
    @State private var showScenes = false

    private let columns = [GridItem(.adaptive(minimum: 120), spacing: 12)]

    var body: some View {
        ScrollView {
            if webShareServer.isRunning, let address = webShareServer.address {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Web Share Active")
                        .font(.headline)
                    Text(address)
                        .font(.caption)
                    Text("PIN: \(webShareServer.pin)")
                        .font(.caption.monospaced())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
            }

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(galleryStore.items) { item in
                    NavigationLink {
                        if let image = galleryStore.image(for: item) {
                            Spatial3DPreviewView(image: image)
                        }
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            if let image = galleryStore.image(for: item) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 120)
                                    .clipped()
                            } else {
                                Rectangle()
                                    .fill(.quaternary)
                                    .frame(height: 120)
                            }
                            Text(item.outputFormat.displayName)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .contextMenu {
                        Button(role: .destructive) {
                            galleryStore.remove(item)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        if let image = galleryStore.image(for: item) {
                            Button("Add to Spatial Scene") {
                                sceneImages.append(image)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Gallery")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("Scenes") { showScenes = true }
                    .disabled(sceneImages.isEmpty)
                Button(webShareServer.isRunning ? "Stop Share" : "Web Share") {
                    toggleWebShare()
                }
            }
        }
        .sheet(isPresented: $showScenes) {
            NavigationStack {
                Spatial3DSceneView(images: sceneImages)
            }
        }
        .overlay {
            if galleryStore.items.isEmpty {
                ContentUnavailableView("No Converted Media", systemImage: "photo.on.rectangle", description: Text("Converted items appear here."))
            }
        }
    }

    private func toggleWebShare() {
        if webShareServer.isRunning {
            webShareServer.stop()
        } else {
            webShareServer.configure(galleryStore: galleryStore)
            try? webShareServer.start()
        }
    }
}
