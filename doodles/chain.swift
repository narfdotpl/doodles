// Function chaining operator experiment.
//
// Tested in Xcode 6 Beta 2.
// Sort of works, but not really. :(



//  Operator

operator infix => { associativity left }

@infix func => <T, U> (x: T, f: (T) -> U) -> U {
    return f(x)
}



// Preparation for demo

extension Array {
    var last: T {
        return self[self.endIndex - 1]
    }
}

extension String {
    func split(separator: Character) -> String[] {
        func splitOnce(s: String) -> (head: String, tail: String?) {
            if let index = find(s, separator) {
                return (s[s.startIndex..index], s[index.succ()..s.endIndex])
            } else {
                return (s, nil)
            }
        }

        var segments: String[] = []

        var head = self
        var tail: String?

        while (true) {
            (head, tail) = splitOnce(head)
            segments.append(head)

            if tail {
                head = tail!
            } else {
                break
            }
        }

        return segments
    }
}

func uniq<T: Hashable>(xs: T[]) -> T[] {
    // create dictionary using `xs` as keys
    var d = Dictionary<T, Bool>()
    for x in xs {
        d[x] = false
    }

    // get dictionary keys as T[]
    var keys: T[] = []
    for key in d.keys {
        keys += key
    }

    return keys
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
//
// error: could not find member 'split'
println(uniq(map(filter(users) { $0.isActive }, { $0.email.split("@").last })))

// using only functions, with chaining
//
// error: could not find member 'split'
println(
    users =>
        { filter($0) { $0.isActive }} =>
        { map($0) { $0.email.split("@").last }} =>
        uniq
)

// using methods, without chaining
println(
    uniq(
        users
            .filter { $0.isActive }
            .map { $0.email.split("@").last }
    )
)

// using methods, with chaining
println(
    users
        .filter { $0.isActive }
        .map { $0.email.split("@").last } =>
        uniq
)
