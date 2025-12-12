#import "/template/aot.typ"

#show: aot.format

//! Define how the input should be parsed to a convenient
//! internal representation. This will be given as input
//! to `aot.solve`.
#aot.parser(input => {
  input.trim("\n").split("\n").map(l => {
    let l = l.split(" ")
    let target = l.at(0).trim(regex("\[|\]")).clusters().map(c => c == "#")
    let len = target.len()
    let joltage = l.last().trim(regex("\{|\}")).split(",").map(int)
    let buttons = l.slice(1, -1).map(b => {
      let nums = b.trim(regex("\(|\)")).split(",").map(int)
      range(len).map(i => i in nums)
    })
    (
      len: len,
      target: target,
      joltage: joltage,
      buttons: buttons,
    )
  })
})

#let show-lights(cfg, on: "#", off: ".") = {
  cfg.map(b => if b { on } else { off }).join("")
}
#let show-jolts(cfg) = {
  cfg.map(str).join(",")
}

//! Define how the parsed input should be pretty-printed
//! for readability.
#aot.printer(parsed => {
  for light in parsed {
    [Target: #show-lights(light.target)\ ]
    [Buttons: #{light.buttons.map(but => show-lights(but, on: "X", off: "_")).join(" ")}\ ]
    [Jolts: #show-jolts(light.joltage)\ ]
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

#aot.hint(7)
#aot.solve(data => {
  let total = 0
  for light in data {
    aot.print((light,))
    let init = (false,) * light.len
    assert(light.target != init)
    let seen = (:)
    seen.insert(show-lights(init), init)
    let prev = seen
    let cost = 0
    let search = true
    while search {
      cost += 1
      let new = (:)
      for cfg in prev.values() {
        for mv in light.buttons {
          let next = cfg.zip(mv).map(((b1, b2),) => b1 != b2)
          if next == light.target {
            aot.log-line[Solved in #cost button presses]
            total += cost
            search = false
            break
          }
          let key = show-lights(next)
          if key not in seen and key not in new {
            new.insert(key, next)
          }
        }
        if not search { break }
      }
      if not search { break }
      if new == (:) {
        panic("Exploration ended with no solution")
      }
      seen += new
      prev = new
    }
  }
  aot.answer(total)
})

=
//! Part 2

#aot.hint(33)
//#aot.draft()
#aot.solve(data => {
  aot.answer[#{
    [(declare-const total Int)]
    linebreak()
    for (idx, light) in data.enumerate() {
      [(declare-const subtotal-#{idx} Int)\ ]
      for butidx in range(light.buttons.len()) {
        [(declare-const press-#{idx}-#{butidx} Int)\ ]
        [(assert (>= press-#{idx}-#{butidx} 0))\ ]
      }
      [(assert (= subtotal-#{idx} (+ #{
        for butidx in range(light.buttons.len()) {
          [press-#{idx}-#{butidx} ]
        } 
      })))\ ]
      for i in range(light.len) {
        [(assert (= #{light.joltage.at(i)} (+ #{
          for (butidx, button) in light.buttons.enumerate() {
            if button.at(i) {
              [press-#{idx}-#{butidx} ]
            }
          }
        })))\ ]
      }
    }
    [(assert (= total (+ #{
      for (idx, _) in data.enumerate() {
        [subtotal-#{idx} ]
      }
    })))\ ]
    [; Do a dichotomy on this to find the maximum value \ ]
    [(assert (<= total 0))\ ]
    [(check-sat)\ ]
    [(get-model)\ ]
  }]
})

