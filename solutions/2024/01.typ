#import "/template/aot.typ"

#show: aot.format

#aot.parser(input => {
  input.split("\n").filter(ln => ln != "").map(ln => ln.split().map(int))
})

=

#aot.hint(11)
#aot.solve(input => {
  let (l, r) = aot.utils.unzip2(input)
  let l = l.sorted()
  let r = r.sorted()
  let pairs = l.zip(r)
  let dists = pairs.map(((a, b),) => calc.abs(a - b))
  let ans = dists.sum()
  aot.answer(ans)
})

=

#aot.hint(31)
#aot.solve(input => {
  let (l, r) = aot.utils.unzip2(input)
  let r = aot.utils.frequency(r, key: str)
  let dist = 0
  for e in l {
    dist += e * r.at(str(e), default: 0)
  }
  aot.answer(dist)
})

