import Foundation

@MainActor
final class Spatial3DBatchConversionQueue: ObservableObject {
    @Published private(set) var queue: [Spatial3DConvertedMedia] = []
    @Published private(set) var isRunning = false

    func enqueue(_ item: Spatial3DConvertedMedia) {
        var queued = item
        queued.status = .queued
        queue.append(queued)
    }

    func clear() {
        queue.removeAll()
    }

    func markComplete(id: UUID) {
        guard let index = queue.firstIndex(where: { $0.id == id }) else { return }
        queue[index].status = .complete
    }

    func markFailed(id: UUID) {
        guard let index = queue.firstIndex(where: { $0.id == id }) else { return }
        queue[index].status = .failed
    }
}
