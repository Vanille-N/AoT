#import "/template/aot.typ"

#show: aot.format

#aot.parser(input => {
  input.trim("\n").split("\n").map(s => s.split("").filter(s => s != "").map(int))
})

=

#aot.hint(357)
#aot.solve(input => {
  let total = 0
  for bank in input {
    let i1 = aot.utils.argmax(bank.slice(0, -1))
    let i2 = aot.utils.argmax(bank.slice(i1 + 1))
    let v1 = bank.at(i1)
    let v2 = bank.at(i1 + i2 + 1)
    total += v1 * 10 + v2
  }
  aot.answer(total)
})

=

#aot.hint(3121910778619)
#aot.solve(input => {
  let total = 0
  for bank in input {
    [Battery bank: #{bank.map(str).join("")} \ ]
    let jolts = 0
    for i in range(12) {
      let end-idx = if i < 11 { i - 11 } else { none }
      let idx = aot.utils.argmax(bank.slice(0, end-idx))
      let val = bank.at(idx)
      jolts = jolts * 10 + val
      [- biggest value remaining in #{bank.slice(0, i - 12).map(str).join("")} is #val at #idx ]
      bank = bank.slice(idx + 1)
    }
    [- Produces #jolts]
    total += jolts
  }
  aot.answer(total)
})

