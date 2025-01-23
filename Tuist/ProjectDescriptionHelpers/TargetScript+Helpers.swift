import ProjectDescription

extension TargetScript {
    static let root = "bin"

    // MARK: - Workflow

    static func swiftLint() -> TargetScript {
        .post(
            path: "\(root)/swift_lint_run_script.sh",
            arguments: [],
            name: "SwiftLint",
            basedOnDependencyAnalysis: false,
            runForInstallBuildsOnly: false
        )
    }

    static func uploadDsyms() -> TargetScript {
        .post(
            path: "\(root)/upload_dsyms.sh",
            arguments: [],
            name: "UploadDsyms",
            basedOnDependencyAnalysis: false,
            runForInstallBuildsOnly: false
        )
    }

    // MARK: - SwiftGen
    static func allAppTargetScripts() -> [TargetScript] {
        let scripts: [TargetScript] = [
            swiftLint(),
            uploadDsyms()
        ]
        return scripts
    }
}
