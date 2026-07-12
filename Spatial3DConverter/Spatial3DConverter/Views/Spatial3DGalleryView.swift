import SwiftUI

struct Spatial3DGalleryView: View {
    @EnvironmentObject private var galleryStore: Spatial3DGalleryStore

    private let columns = [GridItem(.adaptive(minimum: 120), spacing: 12)]

    var body: some View {
        ScrollView {
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
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Gallery")
        .overlay {
            if galleryStore.items.isEmpty {
                ContentUnavailableView("No Converted Media", systemImage: "photo.on.rectangle", description: Text("Converted items appear here."))
            }
        }
    }
}
