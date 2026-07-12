import Foundation
import PhotosUI
import UIKit

struct Spatial3DBatchJob: Identifiable, Equatable {
    let id: UUID
    let title: String
    let mediaType: Spatial3DMediaType
    var photoData: Data?
    var videoURL: URL?
    var settings: Spatial3DConversionSettings
    var status: Spatial3DConversionStatus
}

@MainActor
final class Spatial3DBatchConversionQueue: ObservableObject {
    @Published private(set) var jobs: [Spatial3DBatchJob] = []
    @Published private(set) var isRunning = false
    @Published private(set) var completedCount = 0

    func enqueuePhoto(data: Data, title: String, settings: Spatial3DConversionSettings) {
        jobs.append(Spatial3DBatchJob(
            id: UUID(),
            title: title,
            mediaType: .photo,
            photoData: data,
            settings: settings,
            status: .queued
        ))
    }

    func enqueueVideo(url: URL, title: String, settings: Spatial3DConversionSettings) {
        jobs.append(Spatial3DBatchJob(
            id: UUID(),
            title: title,
            mediaType: .video,
            videoURL: url,
            settings: settings,
            status: .queued
        ))
    }

    func clear() {
        jobs.removeAll()
        completedCount = 0
    }

    func processAll(
        engine: Spatial3DTurboQualityEngine,
        videoPipeline: Spatial3DRealTimeVideoPipeline,
        galleryStore: Spatial3DGalleryStore
    ) async {
        guard !isRunning else { return }
        isRunning = true
        completedCount = 0
        defer { isRunning = false }

        for index in jobs.indices {
            jobs[index].status = .converting
            do {
                switch jobs[index].mediaType {
                case .photo:
                    guard let data = jobs[index].photoData,
                          let image = UIImage(data: data) else {
                        throw Spatial3DConversionError.invalidInput
                    }
                    let item = try await engine.exportConvertedPhoto(
                        image,
                        settings: jobs[index].settings,
                        galleryStore: galleryStore
                    )
                    galleryStore.insert(item)
                case .video:
                    guard let url = jobs[index].videoURL else {
                        throw Spatial3DConversionError.invalidInput
                    }
                    if let output = await videoPipeline.convert(
                        videoURL: url,
                        settings: jobs[index].settings,
                        engine: engine
                    ) {
                        galleryStore.insert(Spatial3DConvertedMedia(
                            type: .video,
                            filePath: output.path,
                            strength: jobs[index].settings.strength,
                            outputFormat: jobs[index].settings.outputFormat,
                            engineMode: jobs[index].settings.engineMode,
                            status: .complete
                        ))
                    } else {
                        throw Spatial3DConversionError.exportFailed("Video conversion failed.")
                    }
                }
                jobs[index].status = .complete
                completedCount += 1
            } catch {
                jobs[index].status = .failed
            }
        }
    }
}
