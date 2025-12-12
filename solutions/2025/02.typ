#import "/template/aot.typ"

#show: aot.format

#aot.parser(input => {
  input.trim("\n").split(",").map(l => l.split("-"))
})

=

#aot.hint(1227775554)
#aot.solve(input => {
  let invalids = ()
  for (lo, hi) in input {
    aot.log-line[Range: #lo - #hi]
    if lo.len() == hi.len() {
      if calc.rem(lo.len(), 2) == 1 {
        aot.log-line[Odd length is safe]
        continue
      }
    } else if lo.len() + 1 == hi.len() {
      if calc.rem(lo.len(), 2) == 1 {
         aot.log-line[hi decides the length]
         lo = "1" + "0" * (hi.len() - 1)
      } else {
         aot.log-line[lo decides the length]
         hi = "9" * lo.len()
      }
      aot.log-line[Real range: #lo - #hi]
    } else {
      aot.log-line[Can't handle this yet]
    }

    let half = int(lo.slice(0, int(lo.len() / 2)))
    let hi = int(hi)
    let lo = int(lo)
    while true {
      let num = int(str(half) + str(half))
      if num > hi { break }
      if num >= lo {
        invalids.push(num)
      }
      half += 1
    }
  }
  aot.log-line[Invalid: #invalids]
  aot.answer(invalids.sum())
})

=

#aot.hint(4174379265)
#aot.solve(input => {
  let actual-ranges = ()
  for (lo, hi) in input {
    if lo.len() == hi.len() {
      actual-ranges.push((lo, hi))
    } else if lo.len() + 1 == hi.len() {
      actual-ranges.push((lo, "9" * lo.len()))
      actual-ranges.push(("1" + "0" * (hi.len() - 1), hi))
    }
  }

  let invalids = ()
  for (lo, hi) in actual-ranges {
    aot.log-line[Range: #lo - #hi]
    let divs = aot.utils.divisors(lo.len())
    for div in divs.filter(d => d != 1) {
      let len = int(lo.len() / div)
      aot.log-line[try dividing in #div repetitions of #len each]
      let piece = int(lo.slice(0, len))
      let hi = int(hi)
      let lo = int(lo)
      while true {
        let num = int(str(piece) * div)
        if num > hi { break }
        if num >= lo {
          aot.log-line[found #num]
          assert(lo <= num and num <= hi)
          assert(num == int(str(num).slice(0, len) * div))
          invalids.push((num, lo, hi))
        }
        piece += 1
      }
    }
  }
  let invalids = invalids.dedup()
  aot.log-line[Invalid: #invalids]
  aot.answer(invalids.map(t => t.at(0)).sum())
})

