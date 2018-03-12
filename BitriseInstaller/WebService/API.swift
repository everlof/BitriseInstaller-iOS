import Foundation
import Result
import RxSwift

class API {

    static let shared = API()

    enum Error: Swift.Error {
        case generic(String)
        case decodingProblem(Swift.Error)
        case networkError(Swift.Error)
    }

    let personalAccessToken = "<YOUR TOKEN>"

    let `protocol`: String = "https"

    let host: String = "api.bitrise.io"

    let apiBase: String = "v0.1"

    let config: URLSessionConfiguration

    let session: URLSession

    private init() {
        self.config = URLSessionConfiguration.ephemeral
        self.session = URLSession(configuration: config)
    }

    private func urlFor(path: String) -> URL {
        return URL(string: String(format: "%@://%@/%@/%@", `protocol`, host, apiBase, path))!
    }

    func me(then: @escaping ((Result<Me, Error>) -> Void)) {
        request(path: "me", then: then)
    }

    private func _apps(then: @escaping ((Result<[App], Error>) -> Void)) {
        request(path: "me/apps", then: then)
    }

    func apps() -> Observable<[App]> {
        return Observable.create { observable in
            self._apps(then: { result in
                switch result {
                case .success(let apps):
                    observable.onNext(apps)
                case .failure(let error):
                    observable.onError(error)
                }
            })
            return Disposables.create()
        }
    }

    func app(_ app: App, then: @escaping ((Result<App, Error>) -> Void)) {
        request(path: "apps/\(app.slug)", then: then)
    }

    private func _builds(for app: App, then: @escaping ((Result<[Build], Error>) -> Void)) {
        request(path: "apps/\(app.slug)/builds", then: then)
    }

    func builds(for app: App) -> Observable<[Build]> {
        return Observable.create { observable in
            self._builds(for: app, then: { result in
                switch result {
                case .success(let apps):
                    observable.onNext(apps)
                case .failure(let error):
                    observable.onError(error)
                }
            })
            return Disposables.create()
        }
    }

    func build(app: App, andBuild build: Build, then: @escaping ((Result<Build, Error>) -> Void)) {
        request(path: "apps/\(app.slug)/builds/\(build.slug)", then: then)
    }

    func artifacts(for app: App, andBuild build: Build, then: @escaping ((Result<[Artifact], Error>) -> Void)) {
        request(path: "apps/\(app.slug)/builds/\(build.slug)/artifacts", then: then)
    }

    func artifact(for app: App,
                  andBuild build: Build,
                  andArtifact artifact: Artifact,
                  then: @escaping ((Result<Artifact, Error>) -> Void)) {
        request(path: "apps/\(app.slug)/builds/\(build.slug)/artifacts/\(artifact.slug)", then: then)
    }

    func get(url: URL, headers: [String: String] = [:], then: @escaping ((Result<String, Error>) -> Void)) {
        var urlRequest = URLRequest(url: url)
        headers.forEach { (key, value) in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        session.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else {
                then(Result<String, Error>(error: .generic("No data from response")))
                return
            }

            guard let string = String(data: data, encoding: .utf8) else {
                then(Result<String, Error>(error: .generic("Can't turn response to string of `utf-8`")))
                return
            }

            then(Result<String, Error>(value: string))
        }.resume()
    }

    private func request<T: Codable>(path: String, then: @escaping ((Result<T, Error>) -> Void)) {
        var urlRequest = URLRequest(url: urlFor(path: path))
        urlRequest.addValue(String(format: "token %@", personalAccessToken), forHTTPHeaderField: "Authorization")

        session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Swift.Error?) in
            guard let data = data else {
                then(Result<T, Error>(error: .generic("No data from response")))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let object = try decoder.decode(Envelope<T>.self, from: data)
                then(Result<T, Error>(value: object.data))
            } catch {
                then(Result<T, Error>(error: .decodingProblem(error)))
            }
        }.resume()
    }

}

struct Envelope<T: Codable>: Codable {
    struct Paging: Codable {
        let next: String?
        let pageItemList: Int
        let totalItemCount: Int

        enum CodingKeys: String, CodingKey {
            case next
            case pageItemList = "page_item_limit"
            case totalItemCount = "total_item_count"
        }
    }

    let data: T
    let paging: Paging?
}
