# SwiftRegex

SwiftRegex is a wrapper library of regular expression libraries, such as POSIX regex.h.

Usage
---

To use swift-regex...

1. Specify swift-regex implementation, using `SwiftRegexImplementation.by` object.
1. An implementation will offer its DSL to configure.

#### Example

```swift
import POSIXRegex
import SwiftRegex

SwiftRegexImplementation.by.usePosix()

guard let regex = pattern(of: "ba").compile() else {
    fatalError { "cannot compile pattern \"ba\"" }
} 

let matcher = regex.matcher(for: "foo-bar-baz")
matcher.matches // -> true
```

Implementations
---

Currently POSIX `regex.h` is the only implementation of SwiftRegex.

TODO
---

* Add API and POSIX implementation of a feature to replace string element.
* Add implementation of RE2
* Add implementation of Oniguruma

Install
---

SwiftRegex uses Swift Package Manager, so you can install this library by SPM.

First, add SwiftRegex to `dependencies`.

```swift
dependencies [
    .package(url: "https://github.com/mike-neck/swift-regex.git", from: "0.1"),
]
```

Second, add `SwiftRegex` and an implementation to your target dependencies.

```swift
targets [
    .target(name: "YourAweSomeApp", dependencies: [
        "SwiftRegex",
        "POSIXRegex",
    ]),
]
```

Third, import `SwiftRegex`(which determines API) and an implementation in your swift file.

```swift
import SwiftRegex // defines API
import POSIXRegex // offers implementation

SwiftRegexImplementation.by.usePosix() // by calling this, pattern function will returns POSIX regexp.
```

How to Implement
---

To implement SwiftRegex, you should offer some protocols.

* `SwiftRegexImplementationRef`
    * The function `createPattern` returns `SwiftRegexPattern` protocol.
    * This protocol is only for a smooth DSL.
* `SwiftRegexPattern`
    * The function `compile` returns `SwiftRegex?`
    * This protocol is responsible for compiling a given regex pattern.
* `SwiftRegex`
    * The function `matcher` returns `RegexMatcher`.
    * Represents a compiled regular expression.
* `RegexMatcher`
    * Represents matching result.
    * offering some matching result.
        * `matches` returns whether the pattern matches the testing string.
* And extend `SwiftRegexImplementation` class to offer DSL, and make `pattern` function to return your implementation.
    * A static property `by` is a singleton object of `SwiftRegexImplementation`.
    * Calling `useImpl(of:)` with `SwiftRegexImplementationRef` from your extension function for `SwiftRegexImplementation`
will makes it available for `pattern` function to return your SwiftRegex implementation. 
