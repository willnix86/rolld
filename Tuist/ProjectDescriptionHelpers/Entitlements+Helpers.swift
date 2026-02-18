import ProjectDescription

extension Entitlements {
    public static func entitlements() -> Entitlements {
        return .dictionary([
            "com.apple.developer.icloud-container-identifiers": .array([.string("iCloud.com.jenix.rolld")]),
            "com.apple.developer.icloud-services": .array([.string("CloudKit")]),
            "com.apple.security.app-sandbox": .boolean(true),
            "com.apple.security.files.user-selected.read-only": .boolean(true),
        ])
    }
}
