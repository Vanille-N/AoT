#import "/template/aot.typ"

#show: aot.format

//! Define how the input should be parsed to a convenient
//! internal representation. This will be given as input
//! to `aot.solve`.
#aot.parser(input => {
  let segments = input.trim("\n").split("\n\n")
  let regions = segments.pop().split("\n").map(line => {
    let (size, counts) = line.split(": ")
    let (width, height) = size.split("x").map(int)
    let counts = counts.split(" ").map(int)
    (size: (width: width, height: height), counts: counts)
  })
  let tiles = segments.map(line => {
    let (id, shape) = line.split(":\n")
    let id = int(id)
    let shape = shape.split("\n").map(str.clusters)
    (id: id, shape: shape)
  })
  (tiles: tiles, regions: regions)
})

//! Define how the parsed input should be pretty-printed
//! for readability.
#aot.printer(parsed => {
  for tile in parsed.tiles {
    [#tile.id:\ ]
    [#{tile.shape.map(l => " " + l.join("")).join("\n")}\ ]
  }
  for region in parsed.regions {
    [#region.size.width x #region.size.height: #{region.counts.map(str).join(",")}\ ]
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

#aot.hint(2)
#aot.solve(data => {
  let fit = 0
  for region in data.regions {
    if region.size.width * region.size.height >= 8 * region.counts.sum() {
      fit += 1
    }
  }
  aot.answer(fit)
})

=
//! Part 2

#aot.hint(none)
#aot.solve(data => {
  none
})

