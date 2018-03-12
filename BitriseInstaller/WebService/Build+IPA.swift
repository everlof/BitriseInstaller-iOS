import Foundation
import Result

extension Build {

    indirect enum IPAError: Error {
        case generic(Error)
        case parsingError(String)
        case underlying(String, IPAError)
    }

    func findManifestURL(for app: App, then: @escaping ((Result<URL, IPAError>) -> Void)) {
        API.shared.artifacts(for: app, andBuild: self) { result in
            switch result {
            case .success(let artifacts):
                artifacts.filter { $0.artifactType == .ipa }.forEach { artifact in
                    API.shared.artifact(for: app, andBuild: self, andArtifact: artifact, then: { result in
                        switch result {
                        case .success(let artifact):
                            self.localPlistInPublicURL(for: artifact, then: then)
                        case .failure(let error):
                            then(Result<URL, IPAError>(error: .generic(error)))
                        }
                    })
                }
            case .failure(let error):
                then(Result<URL, IPAError>(error: .generic(error)))
            }
        }
    }

    private func localPlistInPublicURL(for artifact: Artifact, then: @escaping ((Result<URL, IPAError>) -> Void)) {
        guard let publicInstallPageURL = artifact.publicInstallPageURL else {
            then(Result<URL, IPAError>(error: .parsingError("No URL exist")))
            return
        }

        guard let url = URL(string: publicInstallPageURL) else {
            then(Result<URL, IPAError>(error: .parsingError("Provided URL is not a valid URL.")))
            return
        }

        then(Result<URL, IPAError>(value: url))
    }

    func findInstallURL(for app: App, then: @escaping ((Result<URL, IPAError>) -> Void)) {
        findManifestURL(for: app) { result in
            switch result {
            case .success(let manifestURL):
                API.shared.get(url: manifestURL, headers: [
                    // Need to act as a web-browser
                    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"],
                               then: { result in
                                switch result {
                                case .success(let content):
                                    DispatchQueue.main.async {
                                        if let first = content.matches(for: "itms-services.*?\\.plist").first, let url = URL(string: first) {
                                            UIApplication.shared.open(url, options: [:], completionHandler: { completed in
                                                print("Completed => \(completed)")
                                            })
                                        }
                                    }
                                case .failure(let error):
                                    then(Result<URL, IPAError>(error: .generic(error)))
                                }
                })
            case .failure(let error):
                then(Result<URL, IPAError>(error: .underlying("Can't extract manifest", error)))
            }
        }
    }

}
