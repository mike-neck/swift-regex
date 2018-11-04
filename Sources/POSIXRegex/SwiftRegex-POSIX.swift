import SwiftRegex
import CPOSIXRegex
import Foundation

public extension SwiftRegexImplementation {

    public mutating func usePosix() {
        useImpl(of: PosixImpl())
    }
}

struct SwiftRegexPosixPattern: SwiftRegexPattern {

    let pattern: String

    func compile() -> SwiftRegex? {
        return PosixRegex(pattern)
    }
}

struct PosixImpl: SwiftRegexImplementationRef {
    func createPattern(of pattern: String) -> SwiftRegexPattern {
        return SwiftRegexPosixPattern(pattern: pattern)
    }
}

class PosixRegex: SwiftRegex {
    let pattern: String
    var regex: PosixRegexPointer = NewPosixRegexPointer()

    init?(_ pattern: String) {
        self.pattern = pattern
        let rawPointer = regex.pointer
        guard var ptn = pattern.cString(using: .utf8) else {
            return nil
        }
        let regexCode: PosixRegexCode = regex_compile(rawPointer, &ptn)
        if regexCode.hasError() {
            return nil
        }
    }

    deinit {
        regex_free(&regex)
    }

    public func matcher(for targetString: String, expectedCount: Int = 16) -> RegexMatcher {
        if expectedCount < 1 {
            return PosixRegexMatcher(self.pattern, targetString, nil)
        }
        let size = Int32(expectedCount)
        let regMatch: PosixRegexMatch = NewPosixRegexMatch(size)
        guard var target = targetString.cString(using: .utf8) else {
            return PosixRegexMatcher(self.pattern, targetString, nil)
        }
        let regexCode: PosixRegexCode = regex_exec(regex.pointer, &target, regMatch.match_pointer, size)
        if regexCode.hasError() {
            return PosixRegexMatcher(self.pattern, targetString, nil)
        }
        return PosixRegexMatcher(self.pattern, targetString, regMatch)
    }
}

class PosixRegexMatcher: RegexMatcher {

    let pattern: String
    let target: String
    private var regexMatch: PosixRegexMatch?

    init(_ pattern: String, _ target: String, _ regexMatch: PosixRegexMatch?) {
        self.pattern = pattern
        self.target = target
        self.regexMatch = regexMatch
    }

    deinit {
        if var regmatch = regexMatch {
            regmatch_free(&regmatch)
        }
    }

    var matches: Bool {
        guard let match = regexMatch else {
            return false
        }
        let size = Int(match.size)
        if size < 0 {
            return false
        }
        for index in 0..<size {
            let startIndex = match.startIndex(at: index)
            if startIndex != -1 {
                return true
            }
        }
        return false
    }
}

extension PosixRegexCode {
    func hasError() -> Bool {
        return self.value != REG_OK
    }
}

#if os(macOS)
    typealias Regoff = Int64
#else
    typealias Regoff = Int32
#endif

fileprivate func regoff(_ regoffT: Regoff) -> Int {
#if os(macOS)
    let regoff = Int64(regoffT)
#else
    let regoff = Int32(regoffT)
#endif
    return Int(regoff)
}

extension PosixRegexMatch {
    func startIndex(at idx: Int) -> Int {
        return getCharIndex(idx) { (index: Int32) in regmatch_start_index(self.match_pointer, index) }
    }

    func endIndex(at idx: Int) -> Int {
        return getCharIndex(idx) { (index: Int32) in regmatch_end_index(self.match_pointer, index) }
    }

    private func getCharIndex(_ idx: Int, _ indexFunc: (Int32) -> PosixRegexRegmatchIndex) -> Int {
        let size = Int(self.size)
        guard 0 <= idx && idx < size else {
            return -1
        }

        let index: Int32 = Int32(idx)
        let charIndex: PosixRegexRegmatchIndex = indexFunc(index)
        return regoff(charIndex.value)
    }
}
