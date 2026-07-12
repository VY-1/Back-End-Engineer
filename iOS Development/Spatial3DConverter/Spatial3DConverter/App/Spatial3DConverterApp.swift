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
                .onAppear {
                    webShareServer.configure(galleryStore: galleryStore)
                }
        }
    }
}

struct Spatial3DRootView: View {
    var body: some View {
        TabView {
            NavigationStack {
                Spatial3DHomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }

            NavigationStack {
                Spatial3DConvertView(mediaKind: .photo)
            }
            .tabItem {
                Label("Photo", systemImage: "photo")
            }

            NavigationStack {
                Spatial3DConvertView(mediaKind: .video)
            }
            .tabItem {
                Label("Video", systemImage: "video")
            }

            NavigationStack {
                Spatial3DGalleryView()
            }
            .tabItem {
                Label("Gallery", systemImage: "square.grid.2x2")
            }

            NavigationStack {
                Spatial3DBatchQueueView()
            }
            .tabItem {
                Label("Batch", systemImage: "tray.full")
            }
        }
    }
}
