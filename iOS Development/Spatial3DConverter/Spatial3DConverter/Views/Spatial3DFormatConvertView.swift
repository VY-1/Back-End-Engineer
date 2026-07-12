import PhotosUI
import SwiftUI

struct Spatial3DFormatConvertView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var message: String?

    var body: some View {
        Form {
            Section("Import VR or Spatial Image") {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label("Select Image", systemImage: "photo")
                }
            }

            Section("Actions") {
                Button("VR SBS → Spatial HEIC") {
                    Task { await convertSelected(toSpatial: true) }
                }
            }

            if let message {
                Section {
                    Text(message).font(.footnote)
                }
            }
        }
        .navigationTitle("Format Convert")
    }

    private func convertSelected(toSpatial: Bool) async {
        guard let selectedItem,
              let data = try? await selectedItem.loadTransferable(type: Data.self),
              let image = UIImage(data: data) else {
            message = "Could not load image."
            return
        }

        let temp = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(UUID().uuidString).heic")
        let layout = Spatial3DVRFormatConverter.detectLayout(from: URL(fileURLWithPath: "/tmp/input_sbs.jpg"))

        do {
            if toSpatial {
                try Spatial3DVRFormatConverter.convertVRImageToSpatial(image, layout: layout, outputURL: temp)
                message = "Saved spatial HEIC to \(temp.lastPathComponent)"
            }
        } catch {
            message = error.localizedDescription
        }
    }
}
