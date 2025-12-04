#import "/template/aot.typ"

#show: aot.format

#aot.parser(input => {
  let body = input.trim().split("\n").map(line => {
    let chars = line.split("").filter(s => s != "")
    (" ", ..chars, " ")
  })
  let len = body.at(0).len()
  ((" ",) * len,) + body + ((" ",) * len,)
})
#aot.printer(parsed => {
  raw(parsed.map(line => line.join("")).join("\n"))
})

=

#aot.hint(13)
#aot.solve(input => {
  let accessible = 0
  for i in range(1, input.len() - 1) {
    for j in range(1, input.at(0).len() - 1) {
      if input.at(i).at(j) == "@" {
        let neighbors = 0
        for di in (-1, 0, 1) {
          for dj in (-1, 0, 1) {
            if input.at(i + di).at(j + dj) in ("@", "x") {
              neighbors += 1
            }
          }
        }
        if neighbors <= 4 {
          input.at(i).at(j) = "x"
          accessible += 1
        }
      }
    }
  }
  aot.print(input)
  aot.answer(accessible)
})

=

#aot.hint(43)
#aot.solve(input => {
  let height = input.len()
  let width = input.at(0).len()
  let removed = 0
  while true {
    let removable = 0
    for i in range(1, height - 1) {
      for j in range(1, width - 1) {
        if input.at(i).at(j) == "@" {
          let neighbors = 0
          for di in (-1, 0, 1) {
            for dj in (-1, 0, 1) {
              if input.at(i + di).at(j + dj) in ("@", "x") {
                neighbors += 1
              }
            }
          }
          if neighbors <= 4 {
            input.at(i).at(j) = "x"
            removable += 1
          }
        }
      }
    }
    // Now remove them
    if removable == 0 {
      break
    }
    removed += removable
    for i in range(1, height - 1) {
      for j in range(1, width - 1) {
        if input.at(i).at(j) == "x" {
          input.at(i).at(j) = "."
        }
      }
    }
    aot.print(input)
  }
  aot.answer(removed)
})

