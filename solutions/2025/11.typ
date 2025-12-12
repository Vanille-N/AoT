#import "/template/aot.typ"

#show: aot.format

//! Define how the input should be parsed to a convenient
//! internal representation. This will be given as input
//! to `aot.solve`.
#aot.parser(input => {
  for line in input.trim("\n").split("\n") {
    let (key, val) = line.split(": ")
    (str(key): val.split(" "))
  }
})

//! Define how the parsed input should be pretty-printed
//! for readability.
#aot.printer(parsed => {
  for (dev, ports) in parsed.pairs() {
    [#dev $->$ #ports.join(" ")\ ]
  }
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

#aot.hint(5)
#aot.solve(data => {
  let paths = ("out": 1)
  let stack = (("you", false),)
  // We assume the data is acyclic
  while stack != () {
    let (srv, seen) = stack.pop()
    if seen {
      let count = data.at(srv).map(child => paths.at(child)).sum()
      aot.log-line[There are #count paths from #srv]
      paths.insert(srv, count)
    } else {
      stack.push((srv, true))
      for child in data.at(srv) {
        if not (child in paths) {
          stack.push((child, false))
        }
      }
    }
  }
  aot.answer(paths.at("you"))
})

=
//! Part 2

#aot.hint(2)
#aot.solve(data => {
  let paths = ("out": (fft: 0, dac: 0, both: 0, neither: 1))
  let stack = (("svr", false),)
  // We assume the data is acyclic
  while stack != () {
    let (srv, seen) = stack.pop()
    if seen {
      let count = (fft: 0, dac: 0, both: 0, neither: 0)
      for child in data.at(srv) {
        let ccount = paths.at(child)
        count.fft += ccount.fft
        count.dac += ccount.dac
        count.both += ccount.both
        count.neither += ccount.neither
      }
      if srv == "fft" {
        count.fft += count.neither
        count.both += count.dac
        count.neither = 0
        count.dac = 0
      } else if srv == "dac" {
        count.dac += count.neither
        count.both += count.fft
        count.neither = 0
        count.fft = 0
      }
      aot.log-line[There are #count paths from #srv]
      paths.insert(srv, count)
    } else {
      stack.push((srv, true))
      for child in data.at(srv) {
        if not (child in paths) {
          stack.push((child, false))
        }
      }
    }
  }
  aot.answer(paths.at("svr").both)

})

