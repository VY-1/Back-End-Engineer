import SwiftUI

struct Spatial3DPreviewModeView: View {
    let image: UIImage?
    @Binding var mode: Spatial3DPreviewMode

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
                        TimelineView(.animation(minimumInterval: 0.12)) { timeline in
                            let phase = timeline.date.timeIntervalSinceReferenceDate
                            let toggle = Int(phase / 0.12) % 2 == 0
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .scaleEffect(toggle ? 1.0 : 0.995)
                                .offset(x: toggle ? 0 : 2)
                        }
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
}

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
