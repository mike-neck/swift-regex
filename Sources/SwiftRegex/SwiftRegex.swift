import Foundation


// Regexp before compile.
public protocol SwiftRegexPattern {
    func compile() -> SwiftRegex?
}

// Swift implementation which every Swift Regex implements the api of.
public protocol SwiftRegexImplementationRef {
    func createPattern(of pattern: String) -> SwiftRegexPattern
}

struct NoImpl: SwiftRegexImplementationRef {
    func createPattern(of pattern: String) -> SwiftRegexPattern {
        fatalError("createPattern(pattern:) has not been implemented")
    }
}

public struct SwiftRegexImplementation {

    fileprivate var ref: SwiftRegexImplementationRef = NoImpl()

    private init() {
    }

    public mutating func useImpl(of: SwiftRegexImplementationRef) {
        self.ref = of
    }

    private static var __impl: SwiftRegexImplementation = SwiftRegexImplementation()

    static public var by: SwiftRegexImplementation {
        get {
            return __impl
        }
    }
}

func pattern(of string: String) -> SwiftRegexPattern {
    return SwiftRegexImplementation.by.ref.createPattern(of: string)
}

public protocol SwiftRegex: class {

    var pattern: String { get }

    func matcher(for targetString: String) -> RegexMatcher
}

public protocol RegexMatcher {

    var matches: Bool { get }
}
