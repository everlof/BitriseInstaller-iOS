import Foundation

public extension String {

    public func groupMatches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))

            var stringMatchings = [String]()

            if let result = results.first {
                for i in 0..<result.numberOfRanges {
                    if result.range(at: i).location < nsString.length {
                        stringMatchings.append(nsString.substring(with: result.range(at: i)))
                    } else {
                        stringMatchings.append("")
                    }
                }
            }

            return stringMatchings
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }

    public func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = self as NSString
            return regex.matches(in: self, range: NSRange(location: 0, length: nsString.length)).map {
                nsString.substring(with: $0.range)
            }
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }

}

