#import "/template/aot.typ"
#import aot: lib.union-find as uf

#show: aot.format

//! Define how the input should be parsed to a convenient
//! internal representation. This will be given as input
//! to `aot.solve`.
#aot.parser(input => {
  let lines = input.trim("\n").split("\n")
  let n1 = lines.first()
  let coords = lines.slice(1).map(l => l.split(",").map(int))
  (num: int(n1), coords: coords)
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

#let pairs-by-distance(coords) = {
 aot.utils.crossprod(coords.enumerate(), coords.enumerate())
   .filter((((i1, _), (i2, _)),) => i1 < i2)
   .map((((i1, p1), (i2, p2)),) => {
     let d = calc.sqrt(p1.zip(p2).map(((a, b),) => calc.pow(a - b, 2)).sum())
     (i1, i2, d)
   }).sorted(key: ((_, _, d),) => d)
}

#aot.hint(40)
#aot.solve(data => {
  let universe = uf.init(data.coords.len())
  let distances = pairs-by-distance(data.coords)
  for (i1, i2, _) in distances.slice(0, data.num) {
    let (u, unified) = uf.unify(universe, i1, i2)
    universe = u
  }
  let cls = uf.classes(universe)
  aot.log-line[Classes: #cls]
  let ans = cls.map(array.len).sorted().rev().slice(0, 3).fold(1, (acc, x) => acc * x)
  aot.answer(ans)
})

=
//! Part 2

#aot.hint(25272)
#aot.solve(data => {
  let universe = uf.init(data.coords.len())
  let distances = pairs-by-distance(data.coords)
  let connections = 0
  for (i1, i2, _) in distances {
    let (u, unified) = uf.unify(universe, i1, i2)
    universe = u
    if unified {
      connections += 1
      if connections == data.coords.len() - 1 {
        aot.log-line[Last connected #data.coords.at(i1) with #data.coords.at(i2)]
        aot.answer(data.coords.at(i1).at(0) * data.coords.at(i2).at(0))
        break
      }
    }
  }
})

