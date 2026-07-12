import PhotosUI
import SwiftUI
import UniformTypeIdentifiers

struct Spatial3DConvertView: View {
    let mediaKind: Spatial3DMediaType

    @StateObject private var engine = Spatial3DTurboQualityEngine()
    @StateObject private var videoPipeline = Spatial3DRealTimeVideoPipeline()
    @EnvironmentObject private var galleryStore: Spatial3DGalleryStore

    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedVideoItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var selectedVideoURL: URL?
    @State private var settings = Spatial3DConversionSettings()
    @State private var exportMessage: String?
    @State private var trimStart: Double = 0
    @State private var trimEnd: Double = 30
    @State private var videoDuration: Double = 30
    @State private var showFileExporter = false
    @State private var exportedFileURL: URL?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                pickerSection
                Spatial3DEngineModePicker(mode: $settings.engineMode)
                Spatial3DOutputFormatPicker(format: $settings.outputFormat)

                Slider(value: $settings.strength, in: 0...1) {
                    Text("Depth Strength")
                }

                Spatial3DPreviewModeView(
                    image: videoPipeline.previewFrame ?? engine.previewImage ?? selectedImage,
                    mode: $settings.previewMode
                )

                if mediaKind == .video {
                    Spatial3DVideoTrimmerView(
                        startSeconds: $trimStart,
                        endSeconds: $trimEnd,
                        durationSeconds: videoDuration
                    )
                }

                actionButtons

                if engine.isProcessing || videoPipeline.isRunning {
                    ProgressView(value: max(engine.progress.fractionComplete, videoPipeline.progress.fractionComplete))
                }

                if let exportMessage {
                    Text(exportMessage).font(.footnote).foregroundStyle(.secondary)
                }

                if let error = engine.lastError ?? videoPipeline.lastError {
                    Text(error).font(.footnote).foregroundStyle(.red)
                }
            }
            .padding()
        }
        .navigationTitle(mediaKind == .photo ? "Convert Photo" : "Convert Video")
        .fileExporter(
            isPresented: $showFileExporter,
            document: Spatial3DExportedFileDocument(url: exportedFileURL),
            contentType: .jpeg,
            defaultFilename: "Spatial3DConverted"
        ) { _ in }
        .onChange(of: selectedPhotoItem) { _, item in
            Task { await loadPhoto(from: item) }
        }
        .onChange(of: selectedVideoItem) { _, item in
            Task { await loadVideo(from: item) }
        }
        .onChange(of: settings.strength) { _, _ in
            guard mediaKind == .photo, let selectedImage else { return }
            Task { await engine.updatePreview(from: selectedImage, settings: settings) }
        }
    }

    @ViewBuilder
    private var pickerSection: some View {
        if mediaKind == .photo {
            PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                Label("Select Photo", systemImage: "photo")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        } else {
            PhotosPicker(selection: $selectedVideoItem, matching: .videos) {
                Label("Select Video", systemImage: "video")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
    }

    @ViewBuilder
    private var actionButtons: some View {
        HStack {
            Button("Convert") {
                Task { await convertCurrentMedia() }
            }
            .buttonStyle(.borderedProminent)
            .disabled(!canConvert)

            Button("Save to Photos") {
                Task { await saveToPhotos() }
            }
            .disabled(engine.previewImage == nil && videoPipeline.previewFrame == nil)

            Button("Export File") {
                Task { await exportToFiles() }
            }
            .disabled(engine.previewImage == nil)
        }

        if mediaKind == .video, videoPipeline.isRunning {
            Button("Cancel", role: .destructive) {
                videoPipeline.cancel()
            }
        }
    }

    private var canConvert: Bool {
        mediaKind == .photo ? selectedImage != nil : selectedVideoURL != nil
    }

    private func loadPhoto(from item: PhotosPickerItem?) async {
        guard let item, let data = try? await item.loadTransferable(type: Data.self),
              let image = UIImage(data: data) else { return }
        selectedImage = image
        await engine.updatePreview(from: image, settings: settings)
    }

    private func loadVideo(from item: PhotosPickerItem?) async {
        guard let item, let movie = try? await item.loadTransferable(type: Spatial3DVideoTransferable.self) else { return }
        selectedVideoURL = movie.url
        let asset = AVURLAsset(url: movie.url)
        if let duration = try? await asset.load(.duration) {
            videoDuration = max(duration.seconds, 1)
            trimEnd = min(videoDuration, 30)
        }
    }

    private func convertCurrentMedia() async {
        if mediaKind == .video {
            guard let selectedVideoURL else { return }
            if let output = await videoPipeline.convert(
                videoURL: selectedVideoURL,
                settings: settings,
                engine: engine,
                trimRange: trimStart...trimEnd
            ) {
                galleryStore.insert(Spatial3DConvertedMedia(
                    type: .video,
                    filePath: output.path,
                    strength: settings.strength,
                    outputFormat: settings.outputFormat,
                    engineMode: settings.engineMode,
                    status: .complete
                ))
                exportMessage = "Video converted and saved to gallery."
            }
            return
        }

        guard let selectedImage else { return }
        do {
            let item = try await engine.exportConvertedPhoto(
                selectedImage,
                settings: settings,
                galleryStore: galleryStore
            )
            galleryStore.insert(item)
            exportMessage = "Converted and saved to in-app gallery."
        } catch {
            exportMessage = error.localizedDescription
        }
    }

    private func saveToPhotos() async {
        guard let image = engine.previewImage ?? videoPipeline.previewFrame else { return }
        do {
            try await Spatial3DPhotosExporter.save(image: image)
            exportMessage = "Saved to Photos."
        } catch {
            exportMessage = error.localizedDescription
        }
    }

    private func exportToFiles() async {
        guard let image = engine.previewImage else { return }
        do {
            exportedFileURL = try Spatial3DFilesExporter.export(image: image)
            showFileExporter = true
            exportMessage = "Ready to export file."
        } catch {
            exportMessage = error.localizedDescription
        }
    }
}

import AVFoundation

struct Spatial3DVideoTransferable: Transferable {
    let url: URL

    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { video in
            SentTransferredFile(video.url)
        } importing: { received in
            let copy = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(UUID().uuidString).mov")
            try FileManager.default.copyItem(at: received.file, to: copy)
            return Spatial3DVideoTransferable(url: copy)
        }
    }
}

struct Spatial3DExportedFileDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.jpeg] }
    var url: URL?

    init(url: URL?) { self.url = url }
    init(configuration: ReadConfiguration) throws { self.url = nil }
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        guard let url, let data = try? Data(contentsOf: url) else {
            throw Spatial3DConversionError.exportFailed("Missing export data.")
        }
        return FileWrapper(regularFileWithContents: data)
    }
}
