#import "/template/aot.typ"

#show: aot.format

//! Define how the input should be parsed to a convenient
//! internal representation. This will be given as input
//! to `aot.solve`.
#aot.parser(input => {
  none
})

//! Define how the parsed input should be pretty-printed
//! for readability.
#aot.printer(parsed => {
  [#parsed]
})

=
//! Part 1

//! You can use the following functions.
//! At the toplevel
//! - `aot.solve(data => {..})` to define the algorithm
//! - `aot.hint(42)` to provide the expected result
//! - `aot.draft()` to skip computation on the real input
//! Inside `aot.solve`:
//! - `aot.answer(42)` to return the final result
//! - `aot.print(data)` to pretty-print the input

#aot.hint(none)
#aot.solve(data => {
  none
})

=
//! Part 2

#aot.hint(none)
#aot.solve(data => {
  none
})

