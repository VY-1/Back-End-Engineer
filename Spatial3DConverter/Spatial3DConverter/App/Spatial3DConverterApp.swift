import SwiftUI

@main
struct Spatial3DConverterApp: App {
    @StateObject private var galleryStore = Spatial3DGalleryStore()
    @StateObject private var webShareServer = Spatial3DWebShareServer()

    var body: some Scene {
        WindowGroup {
            Spatial3DRootView()
                .environmentObject(galleryStore)
                .environmentObject(webShareServer)
        }
    }
}

struct Spatial3DRootView: View {
    @EnvironmentObject private var galleryStore: Spatial3DGalleryStore
    @EnvironmentObject private var webShareServer: Spatial3DWebShareServer

    @State private var showConvertPhoto = false
    @State private var showConvertVideo = false
    @State private var showGallery = false
    @State private var showBatch = false

    var body: some View {
        Spatial3DHomeView(
            onConvertPhoto: { showConvertPhoto = true },
            onConvertVideo: { showConvertVideo = true },
            onOpenGallery: { showGallery = true },
            onOpenBatch: { showBatch = true }
        )
        .sheet(isPresented: $showConvertPhoto) {
            NavigationStack {
                Spatial3DConvertView()
            }
        }
        .sheet(isPresented: $showConvertVideo) {
            NavigationStack {
                Spatial3DConvertView()
            }
        }
        .sheet(isPresented: $showGallery) {
            NavigationStack {
                Spatial3DGalleryView()
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(webShareServer.isRunning ? "Stop Share" : "Web Share") {
                                toggleWebShare()
                            }
                        }
                    }
            }
        }
        .sheet(isPresented: $showBatch) {
            NavigationStack {
                Spatial3DBatchQueueView()
            }
        }
    }

    private func toggleWebShare() {
        if webShareServer.isRunning {
            webShareServer.stop()
        } else {
            try? webShareServer.start()
        }
    }
}
