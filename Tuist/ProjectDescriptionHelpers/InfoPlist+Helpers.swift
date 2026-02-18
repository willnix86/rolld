import ProjectDescription

extension InfoPlist {
    public static func defaultModule() -> InfoPlist {
        return .extendingDefault(
            with: [
                "CFBundleVersion": "1.0",
                "UILaunchStoryboardName": "Launch Screen",
                "UIBackgroundModes": ["remote-notification"],
                "ITSAppUsesNonExemptEncryption": false
            ]
        )
    }
}
