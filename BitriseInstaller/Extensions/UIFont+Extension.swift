import UIKit

extension UIFont {

    enum Style: String {
        case thin         = "Thin"
        case ultraLight   = "UltraLight"
        case light        = "Light"
        case regular      = "Regular"
        case medium       = "Medium"
        case semiBold     = "SemiBold"
        case bold         = "Bold"
    }

    static func `default`(size: CGFloat, style: Style = .regular) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-\(style.rawValue)", size: size)!
    }

}

