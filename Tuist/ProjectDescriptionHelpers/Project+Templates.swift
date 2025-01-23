import ProjectDescription

extension Project {
    public enum Constants {
        static let organizationName = "com.jenix"
    }

    /// Helper function to create the Project for this ExampleApp
    public static func app(
        name: String
    ) -> Project {
        let projectTargets: [Target] = {
            Target.makeAppTargets(name: name)
        }()

        return Project(
            name: name,
            organizationName: Constants.organizationName,
            settings: .settings(
                base: [
                    "SWIFT_STRICT_CONCURRENCY": "targeted"
                ]
            ),
            targets: projectTargets
        )
    }
}
