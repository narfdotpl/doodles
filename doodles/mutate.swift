// `mutate` helper to go along with `|>` application operator from Prelude.
//
// Originating from a discussion in a pull request:
// https://github.com/robrix/Prelude/pull/35
//
// I use it in my game: http://narf.pl/checkers
//
// Example:
//
//     cell.selectedBackgroundView = UIView() |> mutate {
//         $0.backgroundColor = UIColor(.Base01)
//     }
//
// There's a version that can work with `struct`s too, but unfortunatelly
// it doesn't work with `|>` and closure has to be declared as accepting
// an `inout` argument:
//
//     mutate(&nameLabel.frame) { (inout f: CGRect) in
//         f.size.width = 666
//     }
//

func mutate<T>(@noescape f: T -> ())(x: T) -> T {
    f(x)
    return x
}

func mutate<T>(inout x: T, @noescape f: inout T -> ()) {
    f(&x)
}
