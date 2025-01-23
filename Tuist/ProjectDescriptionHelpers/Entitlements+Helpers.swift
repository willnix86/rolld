import ProjectDescription

extension Entitlements {
    public static func entitlements() -> Entitlements {
        return .file(path: .relativeToRoot("Rolld/Resources/Rolld.entitlements"))
    }
}
