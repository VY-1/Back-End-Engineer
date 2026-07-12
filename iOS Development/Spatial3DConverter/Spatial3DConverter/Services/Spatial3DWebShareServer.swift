import Darwin
import Foundation
import Network

@MainActor
final class Spatial3DWebShareServer: ObservableObject {
    @Published private(set) var isRunning = false
    @Published private(set) var address: String?
    @Published private(set) var pin: String = ""

    private var listener: NWListener?
    private weak var galleryStore: Spatial3DGalleryStore?

    func configure(galleryStore: Spatial3DGalleryStore) {
        self.galleryStore = galleryStore
    }

    func start(port: UInt16 = 8080) throws {
        stop()
        pin = String(format: "%04d", Int.random(in: 0...9999))
        let params = NWParameters.tcp
        listener = try NWListener(using: params, on: NWEndpoint.Port(rawValue: port)!)

        listener?.newConnectionHandler = { [weak self] connection in
            guard let self else { return }
            Task { @MainActor in
                self.handle(connection: connection)
            }
        }

        listener?.start(queue: .main)
        isRunning = true
        address = "http://\(Self.localWiFiAddress() ?? "localhost"):\(port)"
    }

    func stop() {
        listener?.cancel()
        listener = nil
        isRunning = false
        address = nil
    }

    private func handle(connection: NWConnection) {
        connection.start(queue: .global(qos: .userInitiated))
        connection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { [weak self] data, _, _, _ in
            guard let self, let data, let request = String(data: data, encoding: .utf8) else {
                connection.cancel()
                return
            }
            Task { @MainActor in
                let responseData = self.buildResponseData(for: request)
                connection.send(content: responseData, completion: .contentProcessed { _ in
                    connection.cancel()
                })
            }
        }
    }

    private func buildResponseData(for request: String) -> Data {
        let lines = request.split(separator: "\n", omittingEmptySubsequences: false)
        guard let requestLine = lines.first else {
            return responseData(status: 400, body: Data("Bad Request".utf8), contentType: "text/plain")
        }

        let parts = requestLine.split(separator: " ")
        guard parts.count >= 2 else {
            return responseData(status: 400, body: Data("Bad Request".utf8), contentType: "text/plain")
        }
        let path = String(parts[1])

        if path == "/" || path.hasPrefix("/index") {
            return responseData(status: 200, body: Data(galleryHTML().utf8), contentType: "text/html")
        }

        if path == "/api/gallery" {
            return responseData(status: 200, body: Data(galleryJSON().utf8), contentType: "application/json")
        }

        if path.hasPrefix("/media/") {
            let id = path.replacingOccurrences(of: "/media/", with: "")
            if let item = galleryStore?.items.first(where: { $0.id.uuidString == id }),
               let data = try? Data(contentsOf: URL(fileURLWithPath: item.filePath)) {
                return responseData(status: 200, body: data, contentType: "image/jpeg")
            }
        }

        return responseData(status: 404, body: Data("Not Found".utf8), contentType: "text/plain")
    }

    private func responseData(status: Int, body: Data, contentType: String) -> Data {
        let statusText = status == 200 ? "OK" : status == 404 ? "Not Found" : "Error"
        var header = "HTTP/1.1 \(status) \(statusText)\r\n"
        header += "Content-Type: \(contentType)\r\n"
        header += "Content-Length: \(body.count)\r\n"
        header += "Connection: close\r\n\r\n"
        var data = Data(header.utf8)
        data.append(body)
        return data
    }

    private func galleryJSON() -> String {
        let items = galleryStore?.items ?? []
        let payload = items.map { item in
            "{\"id\":\"\(item.id.uuidString)\",\"type\":\"\(item.type.rawValue)\",\"format\":\"\(item.outputFormat.rawValue)\"}"
        }.joined(separator: ",")
        return "{\"pin\":\"\(pin)\",\"items\":[\(payload)]}"
    }

    private func galleryHTML() -> String {
        """
        <!DOCTYPE html><html><head><meta charset='utf-8'><title>Spatial3D Web Share</title></head>
        <body><h1>Spatial3D Converter</h1><p>PIN: \(pin)</p><div id='items'>Loading…</div>
        <script>
        fetch('/api/gallery').then(r=>r.json()).then(d=>{
          document.getElementById('items').innerHTML = d.items.map(i=>'<div><a href="/media/'+i.id+'">'+i.type+'</a></div>').join('');
        });
        </script></body></html>
        """
    }

    private static func localWiFiAddress() -> String? {
        var address: String?
        var ifaddrPointer: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddrPointer) == 0, let first = ifaddrPointer else { return nil }
        defer { freeifaddrs(ifaddrPointer) }

        for ptr in sequence(first: first, next: { $0.pointee.ifa_next }) {
            let interface = ptr.pointee
            if interface.ifa_addr.pointee.sa_family == UInt8(AF_INET) {
                let name = String(cString: interface.ifa_name)
                if name == "en0" {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(
                        interface.ifa_addr,
                        socklen_t(interface.ifa_addr.pointee.sa_len),
                        &hostname,
                        socklen_t(hostname.count),
                        nil,
                        0,
                        NI_NUMERICHOST
                    )
                    address = String(cString: hostname)
                }
            }
        }
        return address
    }
}
