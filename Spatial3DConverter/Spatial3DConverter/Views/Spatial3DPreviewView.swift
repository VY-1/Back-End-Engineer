import SwiftUI

struct Spatial3DPreviewView: View {
    let image: UIImage

    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        }
        .navigationTitle("Preview")
        .navigationBarTitleDisplayMode(.inline)
    }
}
