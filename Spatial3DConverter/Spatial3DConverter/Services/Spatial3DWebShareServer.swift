import Foundation
import Network

@MainActor
final class Spatial3DWebShareServer: ObservableObject {
    @Published private(set) var isRunning = false
    @Published private(set) var address: String?
    @Published private(set) var pin: String = ""

    private var listener: NWListener?

    func start(port: UInt16 = 8080) throws {
        stop()
        pin = String(format: "%04d", Int.random(in: 0...9999))
        let params = NWParameters.tcp
        listener = try NWListener(using: params, on: NWEndpoint.Port(rawValue: port)!)
        listener?.newConnectionHandler = { connection in
            connection.start(queue: .global(qos: .userInitiated))
        }
        listener?.start(queue: .main)
        isRunning = true
        address = "http://localhost:\(port)"
    }

    func stop() {
        listener?.cancel()
        listener = nil
        isRunning = false
        address = nil
    }
}
