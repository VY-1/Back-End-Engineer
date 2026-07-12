import PhotosUI
import SwiftUI

struct Spatial3DConvertView: View {
    @StateObject private var engine = Spatial3DTurboQualityEngine()
    @StateObject private var videoPipeline = Spatial3DRealTimeVideoPipeline()
    @EnvironmentObject private var galleryStore: Spatial3DGalleryStore

    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var settings = Spatial3DConversionSettings()
    @State private var exportMessage: String?
    @State private var trimStart: Double = 0
    @State private var trimEnd: Double = 30
    @State private var isVideoMode = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                    Label(isVideoMode ? "Select Video (photo picker placeholder)" : "Select Photo", systemImage: "photo")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Spatial3DEngineModePicker(mode: $settings.engineMode)
                Spatial3DOutputFormatPicker(format: $settings.outputFormat)

                Slider(value: $settings.strength, in: 0...1) {
                    Text("Depth Strength")
                }

                Spatial3DPreviewModeView(image: engine.previewImage ?? selectedImage, mode: $settings.previewMode)

                if isVideoMode {
                    Spatial3DVideoTrimmerView(
                        startSeconds: $trimStart,
                        endSeconds: $trimEnd,
                        durationSeconds: max(trimEnd, 30)
                    )
                }

                HStack {
                    Button("Convert") {
                        Task { await convertCurrentMedia() }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(selectedImage == nil && !isVideoMode)

                    Button("Save to Photos") {
                        Task { await saveToPhotos() }
                    }
                    .disabled(engine.previewImage == nil)
                }

                if engine.isProcessing || videoPipeline.isRunning {
                    ProgressView(value: engine.progress.fractionComplete)
                }

                if let exportMessage {
                    Text(exportMessage)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                if let error = engine.lastError ?? videoPipeline.lastError {
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }
            }
            .padding()
        }
        .navigationTitle("Convert")
        .onChange(of: selectedPhotoItem) { _, newItem in
            Task { await loadPhoto(from: newItem) }
        }
        .onChange(of: settings.strength) { _, _ in
            guard let selectedImage else { return }
            Task { await engine.updatePreview(from: selectedImage, settings: settings) }
        }
    }

    private func loadPhoto(from item: PhotosPickerItem?) async {
        guard let item else { return }
        if let data = try? await item.loadTransferable(type: Data.self),
           let image = UIImage(data: data) {
            selectedImage = image
            await engine.updatePreview(from: image, settings: settings)
        }
    }

    private func convertCurrentMedia() async {
        if isVideoMode {
            await videoPipeline.convert(
                videoURL: URL(fileURLWithPath: "/tmp/placeholder.mov"),
                settings: settings,
                trimRange: trimStart...trimEnd
            )
            return
        }
        guard let selectedImage else { return }
        do {
            let output = try await engine.convertPhoto(selectedImage, settings: settings)
            _ = try galleryStore.add(image: output, settings: settings)
            exportMessage = "Converted and saved to in-app gallery."
        } catch {
            exportMessage = error.localizedDescription
        }
    }

    private func saveToPhotos() async {
        guard let image = engine.previewImage else { return }
        do {
            try await Spatial3DPhotosExporter.save(image: image)
            exportMessage = "Saved to Photos."
        } catch {
            exportMessage = error.localizedDescription
        }
    }
}
