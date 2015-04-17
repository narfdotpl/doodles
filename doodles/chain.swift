// Function chaining operator experiment.
//
// Write
//
//     x => f => g => h
//
// instead of
//
//     h(g(f(x)))
//
//
// Tested in Xcode 6.1.
//
// 2015-04-17 udpdate: I use `|>` from https://github.com/robrix/Prelude



//  Operator

infix operator => { associativity left }

func => <T, U> (x: T, f: (T) -> U) -> U {
    return f(x)
}



// Preparation for demo

extension String {
    func split(separator: Character) -> [String] {
        func splitOnce(s: String) -> (head: String, tail: String?) {
            if let index = find(s, separator) {
                return (s[s.startIndex..<index], s[index.successor()..<s.endIndex])
            } else {
                return (s, nil)
            }
        }

        var segments: [String] = []

        var head = self
        var tail: String?

        while true {
            (head, tail) = splitOnce(head)
            segments.append(head)

            if tail != nil {
                head = tail!
            } else {
                break
            }
        }

        return segments
    }
}

func uniq<S: SequenceType, T: Hashable where T == S.Generator.Element>(xs: S) -> [T] {
    // create dictionary using `xs` as keys
    var d: [T: Bool] = [:]
    for x in xs {
        d[x] = false
    }

    return Array(d.keys)
}



// Demo
//
// Get email domains of active users ("gmail.com" and "rodriguez.name").

class User {
    let name: String
    let email: String
    let isActive: Bool

    init(_ name: String, _ email: String, _ isActive: Bool) {
        self.name = name
        self.email = email
        self.isActive = isActive
    }
}

let users = [
    User("Fry", "fry@gmail.com", true),
    User("Leela", "leela@gmail.com", true),
    User("Bender", "bender@rodriguez.name", true),
    User("Zoidberg", "john@zoidberg.name", false),
]

// using only functions, without chaining
println(uniq(map(filter(users) { $0.isActive }, { $0.email.split("@").last! })))

// using only functions, with chaining
println(
    users =>
        { filter($0) { $0.isActive }} =>
        { map($0) { $0.email.split("@").last! }} =>
        uniq
)

// using methods, without chaining
println(
    uniq(
        users
            .filter { $0.isActive }
            .map { $0.email.split("@").last! }
    )
)

// using methods, with chaining
println(
    users
        .filter { $0.isActive }
        .map { $0.email.split("@").last! } =>
        uniq
)
