import ProjectDescription

extension Target {
    private enum Constants {
        static let destinations: Destinations = Set([.iPhone])

        static let deploymentTarget: DeploymentTargets = DeploymentTargets.iOS("17.6")
    }

    // MARK: App
    static func makeAppTargets(
        name: String
    ) -> [Target] {
        let mainTarget = makeTarget(
            name: name,
            product: .app,
            bundleId: "\(Project.Constants.organizationName).\(name.lowercased())",
            infoPlist: InfoPlist.defaultModule(),
            sources: ["\(name)/Sources/**"],
            resources: ["\(name)/Resources/**"],
            entitlements: Entitlements.entitlements(),
            scripts: TargetScript.allAppTargetScripts(),
            dependencies: []
        )
        let testTarget = makeTarget(
            name: "\(name)Tests",
            product: .unitTests,
            bundleId: "\(Project.Constants.organizationName).\(name.lowercased())Tests",
            sources: ["RolldTests/\(name)/**"],
            dependencies: [.target(name: name)]
        )
        return [mainTarget, testTarget]
    }

    // MARK: - Helpers
    private static func makeTarget(
        name: String,
        product: ProjectDescription.Product,
        bundleId: String,
        infoPlist: ProjectDescription.InfoPlist? = .default,
        sources: ProjectDescription.SourceFilesList? = nil,
        resources: ProjectDescription.ResourceFileElements? = nil,
        entitlements: ProjectDescription.Entitlements? = nil,
        scripts: [ProjectDescription.TargetScript] = [],
        dependencies:  [ProjectDescription.TargetDependency] = []
    ) -> ProjectDescription.Target {
        Target.target(
            name: name,
            destinations: Constants.destinations,
            product: product,
            bundleId: bundleId,
            deploymentTargets: Constants.deploymentTarget,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            entitlements: entitlements,
            scripts: scripts,
            dependencies: dependencies
        )
    }
}
