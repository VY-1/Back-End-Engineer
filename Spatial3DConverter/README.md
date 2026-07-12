# Spatial3D Converter

**Spatial3D Converter** is an iOS app that converts 2D photos and videos into Spatial (HEIC / MV-HEVC), SBS VR, and top-bottom VR formats using on-device AI — combining StereoShift-style speed with Spatial Media Toolkit-style output formats.

## Requirements

- macOS with **Xcode 26+**
- iPhone running **iOS 26+** (A17 Pro or newer recommended for real-time video)
- Apple Developer account for device testing

## Quick Start (macOS)

1. Open Xcode → **File → New → Project → iOS App**
2. Product name: **Spatial3D Converter**
3. Organization identifier: e.g. `com.yourteam`
4. Interface: **SwiftUI**, Language: **Swift**
5. Save inside this repo as `Spatial3DConverter/Spatial3DConverter.xcodeproj`
6. Set **Bundle Identifier** to `com.yourteam.Spatial3DConverter`
7. Set **Deployment Target** to **iOS 26.0**
8. Delete the default template Swift files Xcode creates
9. Drag the existing `Spatial3DConverter/` source folder into the project (copy items if needed, create groups)
10. Add `Spatial3DDIBR.metal` to the target **Compile Sources**
11. Add `Spatial3DWebViewer/` as folder reference (optional, for Web Share)
12. Build and run on a physical iPhone

## Project Layout

```
Spatial3DConverter/
├── Spatial3DConverter.xcodeproj      # Create in Xcode on Mac
├── Spatial3DConverter/
│   ├── App/Spatial3DConverterApp.swift
│   ├── Views/Spatial3D*.swift
│   ├── Services/Spatial3D*.swift
│   ├── Models/Spatial3DConvertedMedia.swift
│   ├── Shaders/Spatial3DDIBR.metal
│   └── Resources/                    # Core AI model bundles
├── Spatial3DWebViewer/
├── Spatial3DConverterTests/
└── Spatial3DConverterUITests/
```

## Core AI Models

Download and convert depth models on your Mac using Xcode 26 Core AI tooling:

```bash
# Example: download Depth Anything V2 Small, then convert with coreai-build
huggingface-cli download apple/coreml-depth-anything-v2-small \
  --local-dir ./models/DepthV2Small \
  --include "DepthAnythingV2SmallF16.mlpackage/*"

# Convert to AOT Core AI bundles (Xcode 26)
coreai-build --input ./models/DepthV2Small \
  --output ./Spatial3DConverter/Spatial3DConverter/Resources/Spatial3DDepthV2Small.coreai
```

Repeat for Video Depth Anything (Quality mode) and Depth Anything V2-Base (Photo mode).

## Features Implemented (Scaffold)

- Photo conversion pipeline with depth cache and strength slider
- Turbo / Best Quality engine mode picker
- Output format picker (Spatial Photo, Spatial Video, SBS, Top-Bottom)
- Preview modes (wiggle, cross-eye, parallel, SBS)
- In-app gallery with delete
- Batch queue UI scaffold
- Web Share server scaffold + LAN viewer HTML
- Real-time video pipeline scaffold (wire Core AI + AVFoundation on device)

## Next Steps on Device

1. Replace placeholder depth inference in `Spatial3DDepthEstimationService` with Core AI model execution
2. Wire `Spatial3DRealTimeVideoPipeline` to triple-buffer decode → infer → DIBR → MV-HEVC encode
3. Complete MV-HEVC spatial metadata in `Spatial3DSpatialVideoWriter`
4. Implement full `Spatial3DVRFormatConverter` read/write paths
5. Add StoreKit 2 IAP for Pro features

## Privacy

All processing is on-device. No media is uploaded to cloud servers.

## License

Add your license here.
