#import "/template/aot.typ"

#show: aot.format

#aot.parser(input => {
  input.split("\n").filter(s => s != "").map(instr => {
    let dir = instr.at(0)
    let num = int(instr.slice(1))
    if dir == "L" { -num } else { num }
  })
})

=

#aot.hint(3)
#aot.solve(input => {
  let cur = 50
  let zeroed = 0
  for mv in input {
    cur = calc.rem(cur + mv, 100)
    if cur == 0 {
      zeroed += 1
    }
  }
  aot.answer(zeroed)
})

=

#aot.hint(6)
#aot.solve(input => {
  let cur = 50
  let zeroed = 0
  for mv in input {
    [Move: #mv \ ]
    while mv > 100 {
      [- Full rotation \ ]
      zeroed += 1
      mv -= 100
    }
    while mv < -100 {
      [- Full rotation \ ]
      zeroed += 1
      mv += 100
    }
    let next = cur + mv
    if next <= 0 and cur > 0 {
      [- Went below and past 0 to #next \ ]
      zeroed += 1
    } else if next == -100 and cur == 0 {
      [- Full negative turn to #next]
      zeroed += 1
    } else if next >= 100 {
      [- Full positive turn to #next]
      zeroed += 1
    }
    cur = calc.rem-euclid(next, 100)
    [Pointing at #cur \ ]
  }
  aot.answer(zeroed)
})

