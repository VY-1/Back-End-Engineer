# Spatial3D Converter

**Spatial3D Converter** converts 2D photos and videos into Spatial (HEIC / MV-HEVC), SBS VR, and top-bottom VR formats using on-device AI — optimized for **iOS 26+**.

## Requirements

- macOS with **Xcode 26+**
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (optional, recommended)
- iPhone **iOS 26+** (A17 Pro or newer recommended for real-time video)

## Quick Start

### Option A — XcodeGen (recommended)

```bash
git clone https://github.com/VY-1/iOS-Developments.git
cd iOS-Developments/Spatial3DConverter
brew install xcodegen   # if needed
xcodegen generate
open Spatial3DConverter.xcodeproj
```

Set your **Development Team** in the project, then build on a physical iPhone.

### Option B — Manual Xcode project

See the README section in the initial scaffold: create an iOS App target named **Spatial3D Converter** (`Spatial3DConverter`) and import the `Spatial3DConverter/` source folder.

## Download Core AI Models

```bash
./scripts/download_spatial3d_models.sh
```

Add generated `Resources/*.coreai` bundles to the app target. Replace `Spatial3DPlaceholderCoreAIProvider` with your Core AI integration in `Spatial3DCoreAIModelProvider.swift`.

## Features

| Feature | Status |
|---------|--------|
| Photo → Spatial / SBS / Top-Bottom | Implemented |
| Video → Spatial / SBS (real-time pipeline) | Implemented (device testing required) |
| Turbo / Best Quality engine modes | Implemented |
| Depth cache + instant strength slider | Implemented |
| Preview modes (wiggle, cross-eye, parallel, SBS) | Implemented |
| Save to Photos / export file | Implemented |
| In-app gallery + Spatial Scenes | Implemented |
| Batch conversion queue | Implemented |
| VR ↔ Spatial format conversion | Implemented |
| Local Web Share (PIN + LAN gallery) | Implemented |
| Core AI model integration | Placeholder — wire on Mac |

## Architecture

- **`Spatial3DTurboQualityEngine`** — photo + per-frame video processing
- **`Spatial3DRealTimeVideoPipeline`** — AVAssetReader → depth → DIBR → AVAssetWriter
- **`Spatial3DDepthCache`** — cached depth maps for instant re-stereo
- **`Spatial3DVRFormatConverter`** — SBS/TB ↔ Spatial HEIC
- **`Spatial3DWebShareServer`** — local HTTP gallery for VR browsers

## Privacy

All processing is on-device. Web Share serves media only on your local network with a PIN.

## License

Add your license here.
