import UIKit

class MainTabBarViewController: UITabBarController {

    init() {
        super.init(nibName: nil, bundle: nil)
        setViewControllers([
            ListAppsViewController().inNavigationController
        ], animated: false)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
