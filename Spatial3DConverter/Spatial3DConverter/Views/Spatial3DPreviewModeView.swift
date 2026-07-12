import SwiftUI

struct Spatial3DEngineModePicker: View {
    @Binding var mode: Spatial3DEngineMode

    var body: some View {
        Picker("Engine", selection: $mode) {
            ForEach(Spatial3DEngineMode.allCases) { engineMode in
                Text(engineMode.displayName).tag(engineMode)
            }
        }
        .pickerStyle(.segmented)
    }
}

struct Spatial3DOutputFormatPicker: View {
    @Binding var format: Spatial3DOutputFormat

    var body: some View {
        Picker("Output", selection: $format) {
            ForEach(Spatial3DOutputFormat.allCases) { output in
                Text(output.displayName).tag(output)
            }
        }
        .pickerStyle(.menu)
    }
}

struct Spatial3DPreviewModeView: View {
    let image: UIImage?
    @Binding var mode: Spatial3DPreviewMode
    @State private var showLeftEye = true

    var body: some View {
        VStack(spacing: 12) {
            Picker("Preview", selection: $mode) {
                ForEach(Spatial3DPreviewMode.allCases) { previewMode in
                    Text(previewMode.displayName).tag(previewMode)
                }
            }
            .pickerStyle(.segmented)

            Group {
                if let image {
                    switch mode {
                    case .wiggle:
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .opacity(showLeftEye ? 1 : 0.92)
                            .scaleEffect(showLeftEye ? 1 : 0.995)
                            .onAppear { startWiggle() }
                    default:
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    }
                } else {
                    ContentUnavailableView("No Preview", systemImage: "photo", description: Text("Select media to preview."))
                }
            }
            .frame(maxHeight: 360)
        }
    }

    private func startWiggle() {
        guard mode == .wiggle else { return }
        Timer.scheduledTimer(withTimeInterval: 0.12, repeats: true) { _ in
            showLeftEye.toggle()
        }
    }
}
