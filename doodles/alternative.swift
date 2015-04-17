// Alternative:
//
//     if x == 0 ||| 1 {
//         // ...
//     }
//

struct Alternative<T> {
    let values: [T]
}


infix operator ||| {
    associativity left
    precedence 200  // I don't know, something higher than `==`
}

func ||| <T>(a: T, b: T) -> Alternative<T> {
    return Alternative(values: [a, b])
}

func ||| <T>(x: T, a: Alternative<T>) -> Alternative<T> {
    return Alternative(values: a.values + [x])
}

func ||| <T>(a: Alternative<T>, x: T) -> Alternative<T> {
    return x ||| a
}


func == <T: Equatable>(x: T, a: Alternative<T>) -> Bool {
    for v in a.values {
        if x == v {
            return true
        }
    }

    return false
}

func == <T: Equatable>(a: Alternative<T>, x: T) -> Bool {
    return x == a
}

func != <T: Equatable>(x: T, a: Alternative<T>) -> Bool {
    return !(x == a)
}

func != <T: Equatable>(a: Alternative<T>, x: T) -> Bool {
    return x != a
}


let x = 0
assert(x == 0 ||| 1)
assert(x != 1 ||| 2)
assert(x == 0 ||| 1 ||| 2 ||| 3)


enum Enum {
    case Foo
    case Bar
    case Baz
}

let x2 = Enum.Foo
assert(x2 == .Foo ||| .Bar)
assert(x2 != .Bar ||| .Baz)
