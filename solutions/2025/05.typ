#import "/template/aot.typ"
#import aot.lib.interval-tree as itree

#show: aot.format

// Define how the input should be parsed to a convenient
// internal representation. This will be given as input
// to `aot.solve`.
#aot.parser(input => {
  let (intervals, products) = input.split("\n\n")
  let intervals = intervals.split("\n").map(l => {
    l.split("-").map(int)
  }).dedup()
  let products = products.trim("\n").split("\n").map(int)
  (intervals: intervals, products: products)
})

// Define how the parsed input should be pretty-printed
// for readability.
#aot.printer(parsed => [
  Intervals: #itree.print(parsed.intervals)

  Products: #parsed.products
])

=
// Part 1

// You can use the following functions.
// At the toplevel
// - `aot.solve(data => {..})` to define the algorithm
// - `aot.hint(42)` to provide the expected result
// - `aot.draft()` to skip computation on the real input
// Inside `aot.solve`:
// - `aot.answer(42)` to return the final result
// - `aot.print(data)` to pretty-print the input

#aot.hint(3)
#aot.solve(data => {
  let (intervals, products) = data
  let tree = itree.build(intervals)
  let ok = 0
  for prod in products {
    let overlap = itree.overlap(tree, prod)
    [- #prod is in #overlap]
    if overlap != () {
      ok += 1
    }
  }
  aot.answer(ok)
})

=
// Part 2

#aot.hint(14)
#aot.solve(data => {
  let (intervals, products) = data
  let tree = itree.build(intervals)
  let valid = 0
  for intv in intervals.sorted(key: intv => intv.at(0)) {
    [Interval: #intv \ ]
    let touching = itree.overlap(tree, intv.at(0)).filter(i => {
      i.at(0) < intv.at(0) or (i.at(0) == intv.at(0) and i.at(1) < intv.at(1))
    })
    let max-end = calc.max(0, ..touching.map(it => it.at(1)))
    [- Overlaps with: #touching, covering up to #max-end]
    let true-start = calc.max(max-end + 1, intv.at(0))
    [- True interval contribution: (#true-start, #intv.at(1))]
    if true-start <= intv.at(1) {
      valid += intv.at(1) - true-start + 1
    }
  }
  aot.answer(valid)
})

