#import "/template/aot.typ"

#show: aot.format

// Define how the input should be parsed to a convenient
// internal representation. This will be given as input
// to `aot.solve`.
#aot.parser(input => {
  input.trim("\n").split("\n")
})

// Define how the parsed input should be pretty-printed
// for readability.
#aot.printer(parsed => {
  [#parsed]
})

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
// - `aot.log-line[Message]` for log messages.
//   They must fit on a single line in the source code to be properly elided.

#aot.hint(4277556)
#aot.solve(data => {
  let data = data.map(s => s.split(regex(" +")).filter(s => s != ""))
  aot.log-line[Interpreted as #data]
  let numbers = array.zip(..data.slice(0, -1))
  let ops = data.at(-1)
  let intermediate = ()
  for (op, column) in ops.zip(numbers) {
    let column = column.map(int)
    if op == "+" {
      let sum = column.sum()
      aot.log-line[#{column.map(str).join(" + ")} = #sum]
      intermediate.push(sum)
    } else if op == "*" {
      let prod = column.fold(1, (p, x) => p * x)
      aot.log-line[#{column.map(str).join(" * ")} = #prod]
      intermediate.push(prod)
    } else {
      panic("Unsupported operation: " + op)
    }
  }
  let total = intermediate.sum()
  aot.log-line[total: #{intermediate.map(str).join(" + ")} = #total]
  aot.answer(total)
})

=
// Part 2

#aot.hint(3263827)
#aot.solve(data => {
  let data = array.zip(..data.map(str.clusters))
    .map(s => s.join(""))
    .join("\n")
    .split(regex("\n *\n"))
    .map(s => s.split("\n"))
    .map(line => {
      let fst = line.at(0)
      let op = fst.at(-1)
      let fst = fst.slice(0, -1)
      (op, fst, ..line.slice(1))
    })
  aot.log-line[Interpreted as #data]
  let intermediate = ()
  for line in data {
    let op = line.at(0)
    let nums = line.slice(1).map(s => int(s.trim(" ")))
    if op == "+" {
      let sum = nums.sum()
      aot.log-line[#{nums.map(str).join(" + ")} = #sum]
      intermediate.push(sum)
    } else if op == "*" {
      let prod = nums.fold(1, (p, x) => p * x)
      aot.log-line[#{nums.map(str).join(" * ")} = #prod]
      intermediate.push(prod)
    } else {
      panic("Unsupported operation: " + op)
    }
  }
  let total = intermediate.sum()
  aot.log-line[total: #{intermediate.map(str).join(" + ")} = #total]
  aot.answer(total)
})

