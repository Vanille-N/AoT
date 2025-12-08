#import "/template/aot.typ"

#show: aot.format

//! Define how the input should be parsed to a convenient
//! internal representation. This will be given as input
//! to `aot.solve`.
#aot.parser(input => {
  let block = input.trim("\n").split("\n").map(str.clusters)
  let width = block.at(0).len()
  block
})

//! Define how the parsed input should be pretty-printed
//! for readability.
#aot.printer(parsed => {
  parsed.map(s => s.join("")).join("\n")
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

#aot.hint(21)
#aot.solve(data => {
  let width = data.at(0).len()
  let splits = 0
  for i in range(data.len()) {
    for j in range(width) {
      if data.at(i).at(j) == "." {
        if data.at(i - 1).at(j) in ("|", "S") {
          data.at(i).at(j) = "|"
        }
      } else if data.at(i).at(j) == "^" {
        if data.at(i - 1).at(j) in ("|", "S") {
          splits += 1
          for dj in (-1, 1) {
            if data.at(i).at(j + dj) == "." {
              data.at(i).at(j + dj) = "|"
            }
          }
        }
      }
    }
  }
  aot.print(data)
  aot.answer(splits)
})

=
//! Part 2

#aot.hint(40)
#aot.solve(data => {
  let width = data.at(0).len()
  for j in range(width) {
    assert(data.last().at(j) == ".")
    data.last().at(j) = 1
  }
  for i in range(data.len() - 1).rev() {
    aot.log-line[Layer: #{data.at(i).join("")}]
    for j in range(width) {
      if data.at(i).at(j) == "." {
        data.at(i).at(j) = data.at(i + 1).at(j)
      } else if data.at(i).at(j) == "^" {
      data.at(i).at(j) = {
          data.at(i + 1).at(j - 1) + data.at(i + 1).at(j + 1)
        }
      } else if data.at(i).at(j) == "S" {
        aot.answer(data.at(i + 1).at(j))
      } else {
        panic("Malformed element: " + data.at(i).at(j))
      }
    }
    aot.log-line[Timelines: #{data.at(i).map(str).join(",")}]
  }
})

