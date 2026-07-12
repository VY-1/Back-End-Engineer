import SwiftUI

struct Spatial3DVideoTrimmerView: View {
    @Binding var startSeconds: Double
    @Binding var endSeconds: Double
    let durationSeconds: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Trim Video")
                .font(.headline)
            Text("Start: \(startSeconds, specifier: "%.1f")s  End: \(endSeconds, specifier: "%.1f")s")
                .font(.caption)
                .foregroundStyle(.secondary)
            Slider(value: $startSeconds, in: 0...max(endSeconds - 0.5, 0))
            Slider(value: $endSeconds, in: min(startSeconds + 0.5, durationSeconds)...durationSeconds)
        }
        .padding(.vertical, 4)
    }
}
