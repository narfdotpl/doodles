// Custom `while`.
//
// Implemented after reading the words "This is the closest I could get
// to a custom while form" from
// http://matt.might.net/articles/implementing-laziness/
// :)
//
// Tested in Xcode 6.1.

func customWhile(condition: @autoclosure () -> Bool, body: () -> ()) {
    if condition() {
        body()
        // "funny" that both `condition()` and `condition` work...
        customWhile(condition(), body)
    }
}


var i = 3

customWhile(i > 0) {
    println(i)
    i -= 1
}


// It seems that the compiler performs tail call optimisation.
//
// With no optimisation, it crashes:
//
//     > xcrun swift custom_while.swift
//     ...
//     261721
//     261722
//     261723
//     zsh: segmentation fault  xcrun swift custom_while.swift
//
// With optimisation it goes on and on:
//
//     > xcrun swift -O custom_while.swift
//     ...
//     5671260
//     5671261
//     5671262^C
//

let test = false

func f() {
    println(i)
    i += 1
    f()
}

if test {
    i = 1
    f()
}
