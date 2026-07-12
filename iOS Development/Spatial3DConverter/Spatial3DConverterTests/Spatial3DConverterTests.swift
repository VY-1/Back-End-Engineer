import Testing
@testable import Spatial3DConverter

@Test func spatial3DOutputFormatDisplayNames() {
    #expect(Spatial3DOutputFormat.spatialPhoto.displayName == "Spatial Photo")
    #expect(Spatial3DEngineMode.turbo.displayName == "Turbo")
}

@Test func spatial3DVRLayoutDetection() {
    let sbs = URL(fileURLWithPath: "/tmp/sample_sbs.jpg")
    #expect(Spatial3DVRFormatConverter.detectLayout(from: sbs) == .sideBySide)
    let tb = URL(fileURLWithPath: "/tmp/sample_tb.mp4")
    #expect(Spatial3DVRFormatConverter.detectLayout(from: tb) == .topBottom)
}

@Test func spatial3DConversionSettingsDefaults() {
    let settings = Spatial3DConversionSettings()
    #expect(settings.strength == 0.5)
    #expect(settings.engineMode == .turbo)
}
