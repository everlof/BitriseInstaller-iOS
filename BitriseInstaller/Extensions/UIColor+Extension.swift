import UIKit

extension UIColor {

    struct Text {

        static var gray: UIColor {
            return UIColor(red: 149/255, green: 149/255, blue: 149/255, alpha: 1)
        }

        static var black: UIColor {
            return UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }

    }

    static var success: UIColor {
        return UIColor(red: 75/255, green: 181/255, blue: 67/255, alpha: 1)
    }

    static var failure: UIColor {
        return UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
    }

}
