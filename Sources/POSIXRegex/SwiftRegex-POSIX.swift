import SwiftRegex
import CPOSIXRegex
import Foundation

extension SwiftRegexImplementation {

    public mutating func usePosix() {

    }
}

struct SwiftRegexPosixPattern: SwiftRegexPattern {

    let pattern: String

    func compile() -> SwiftRegex? {
        fatalError("compile() has not been implemented")
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

    public func matcher(for targetString: String) -> RegexMatcher {

    }
}

class PosixRegexMatcher: RegexMatcher {

    let pattern: String
    let target: String
    private var regexMatch: PosixRegexMatch
    private let regexPointer: PosixRegexPointer

    init(_ pattern: String, _ target: String, _ regexMatch: PosixRegexMatch, _ regexPointer: PosixRegexPointer) {
        self.pattern = pattern
        self.target = target
        self.regexMatch = regexMatch
        self.regexPointer = regexPointer
    }

    deinit {
        regmatch_free(&regexMatch)
    }

    var matches: Bool {
        let size = Int(regexMatch.size)
        if size < 0 {
            return false
        }
        for index in 0..<size {
            let startIndex = regexMatch.startIndex(at: index)
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
        guard 0 < idx && idx < size else {
            return -1
        }

        let index: Int32 = Int32(idx)
        let charIndex: PosixRegexRegmatchIndex = indexFunc(index)
        return regoff(charIndex.value)
    }
}
