import UIKit

class BuildDetailViewController: UIViewController {

    let app: App

    let build: Build

    init(app: App, build: Build) {
        self.app = app
        self.build = build
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        build.findInstallURL(for: app) { result in
            switch result {
            case .success(let installURL):
                DispatchQueue.main.async {
                    UIApplication.shared.open(installURL, options: [:], completionHandler: { completed in
                        print("Completed => \(completed)")
                    })
                }
            case .failure(let error):
                print("Error => \(error)")
            }
        }
    }

}
