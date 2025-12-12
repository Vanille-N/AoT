#import "/template/aot.typ"

#show: aot.format

//! Define how the input should be parsed to a convenient
//! internal representation. This will be given as input
//! to `aot.solve`.
#aot.parser(input => {
  input.trim("\n").split("\n").map(l => l.split(",").map(int).rev()).rev()
})

//! Define how the parsed input should be pretty-printed
//! for readability.
#aot.printer(parsed => {
  [#parsed]
})

#let show-grid(pts, select: none) = context {
  assert(aot._printing.get())
  assert(pts.len() < 20)
  let maxi = pts.fold((i: 0, j: 0), (acc, pt) => {
    acc.i = calc.max(acc.i, pt.at(0))
    acc.j = calc.max(acc.j, pt.at(1))
    acc
  })
  assert(maxi.i < 15)
  assert(maxi.j < 15)
  let grid = ((".",) * (maxi.j + 2),) * (maxi.i + 2)
  for (i,j) in pts {
    grid.at(i).at(j) = "#"
  }
  if select != none {
    let ((i1, j1), (i2, j2)) = select
    for i in range(calc.min(i1, i2), calc.max(i1, i2) + 1) {
      for j in range(calc.min(j1, j2), calc.max(j1, j2) + 1) {
        grid.at(i).at(j) = "O"
      }
    }
  }
  [#{grid.map(l => l.join("")).join("\n")}]
}

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

#aot.hint(50)
#aot.solve(data => {
  let best = 0
  for (p1, p2) in aot.utils.crossprod(data, data) {
    let (i1, j1) = p1
    let (i2, j2) = p2
    let area = (calc.abs(i1 - i2) + 1) * (calc.abs(j1 - j2) + 1)
    if area > best {
      best = area
      aot.log-line[Improved into #best:]
      aot.log-line(() => [#show-grid(data, select: (p1, p2))])
      aot.log-line[]
    }
  }
  aot.answer(best)
})

=
//! Part 2

#aot.hint(24)
//#aot.draft()
#aot.solve(data => {
  let best = 0
  for (p1, p2) in aot.utils.crossprod(data, data) {
    let (i1, j1) = p1
    let (i2, j2) = p2
    let (i1, i2) = (i1, i2).sorted()
    let (j1, j2) = (j1, j2).sorted()
    let area = (i2 - i1 + 1) * (j2 - j1 + 1)
    if area <= best { continue }
    //aot.log-line[Candidate for #area:]
    //aot.log-line(() => [#show-grid(data, select: (p1, p2))])
    let problem = none
    // Heuristics for eliminating bad rectangles.
    // This is incomplete.
    for other in data {
      if i1 < other.at(0) and other.at(0) < i2 and j1 < other.at(1) and other.at(1) < j2 {
        aot.log-line[Candidate contains a point]
        problem = other
        break
      }
    }
    for segment in (data + (data.at(0),)).windows(2) {
      let (start, end) = segment
      if start.at(0) == end.at(0) {
        // horizontal segment
        if i1 < start.at(0) and start.at(0) < i2 {
          let (lo, hi) = (start.at(1), end.at(1)).sorted()
          if not (hi <= j1 or j2 <= lo) {
            //aot.log-line[Candidate intersects a horizontal segment]
            problem = segment
            break
          }
        }
      } else {
        // vertical segment
        if j1 < start.at(1) and start.at(1) < j2 {
          let (lo, hi) = (start.at(0), end.at(0)).sorted()
          if not (hi <= i1 or i2 <= lo) {
            //aot.log-line[Candidate intersects a vertical segment]
            problem = segment
            break
          }
        }
      }
    }
    if problem == none {
      //aot.log-line[Candidate approved]
      best = area
    } else {
    }
    aot.log-line[]
  }
  aot.answer(best)
})

