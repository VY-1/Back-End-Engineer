import PhotosUI
import SwiftUI

struct Spatial3DBatchQueueView: View {
    @StateObject private var queue = Spatial3DBatchConversionQueue()
    @StateObject private var engine = Spatial3DTurboQualityEngine()
    @StateObject private var videoPipeline = Spatial3DRealTimeVideoPipeline()

    @EnvironmentObject private var galleryStore: Spatial3DGalleryStore

    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var settings = Spatial3DConversionSettings()

    var body: some View {
        VStack(spacing: 12) {
            PhotosPicker(selection: $selectedItems, maxSelectionCount: 20, matching: .any(of: [.images, .videos])) {
                Label("Add to Queue", systemImage: "plus.circle")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .onChange(of: selectedItems) { _, items in
                Task { await enqueue(items) }
            }

            Spatial3DEngineModePicker(mode: $settings.engineMode)
            Spatial3DOutputFormatPicker(format: $settings.outputFormat)

            if queue.isRunning {
                ProgressView("Converting \(queue.completedCount)/\(queue.jobs.count)…")
            }

            List {
                ForEach(queue.jobs) { job in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(job.title)
                            Text("\(job.mediaType.rawValue.capitalized) · \(job.status.rawValue.capitalized)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                }
            }

            HStack {
                Button("Convert All") {
                    Task {
                        await queue.processAll(
                            engine: engine,
                            videoPipeline: videoPipeline,
                            galleryStore: galleryStore
                        )
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(queue.jobs.isEmpty || queue.isRunning)

                Button("Clear") { queue.clear() }
                    .disabled(queue.jobs.isEmpty || queue.isRunning)
            }
            .padding()
        }
        .navigationTitle("Batch Queue")
    }

    private func enqueue(_ items: [PhotosPickerItem]) async {
        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self),
               UIImage(data: data) != nil {
                queue.enqueuePhoto(
                    data: data,
                    title: "Photo \(queue.jobs.count + 1)",
                    settings: settings
                )
                continue
            }
            if let video = try? await item.loadTransferable(type: Spatial3DVideoTransferable.self) {
                queue.enqueueVideo(
                    url: video.url,
                    title: "Video \(queue.jobs.count + 1)",
                    settings: settings
                )
            }
        }
        selectedItems = []
    }
}
