// swift-tools-version: 6.0
import PackageDescription

#if TUIST
import ProjectDescription
import struct ProjectDescription.PackageSettings

let baseSettings = Settings.settings(
    base: [
        "IPHONEOS_DEPLOYMENT_TARGET": "17.0"
    ],
    debug: [:],
    release: [:],
    defaultSettings: .recommended
)

let packageSettings = PackageSettings(
    productTypes: [:],
    baseSettings: baseSettings
)
#endif

let package = Package(
    name: "Rolld",
    dependencies: []
)
