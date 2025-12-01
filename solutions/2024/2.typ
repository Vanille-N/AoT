#import "/template/aot.typ"

#show: aot.format

#aot.parser(input => {
  input.split("\n").filter(x => x != "").map(s => s.split(" ").filter(x => x != "").map(int))
})

#let issues(line) = {
  let vees = ()
  let conflicts = ()

  for (idx, (l, r)) in line.windows(2).enumerate() {
    let diff = calc.abs(l - r)
    if not (1 <= diff and diff <= 3) {
      conflicts.push((idx, idx + 1))
    }
  }
  for (idx, (l, m, r)) in line.windows(3).enumerate() {
    if (l <= m) != (m <= r) {
      vees.push((idx, idx+1, idx+2))
    }
  }
  (conflicts: conflicts, vees: vees)
}

=

#aot.hint(2)
#aot.solve(input => {
  let safe = 0
  for line in input {
    let (vees, conflicts) = issues(line)
    if conflicts != () {
      [#line is unsafe due to a distance\ ] 
    } else if vees != () {
      [#line is unsafe due to a vee\ ]
    } else {
      safe += 1
      [#line is safe\ ]
    }
  }
  aot.answer(safe)
})

=

#aot.hint(4)
#aot.solve(input => {
    let safe = 0
  for line in input {
    let (vees, conflicts) = issues(line)

    let dampening-candidates = (conflicts + vees).flatten().sorted().dedup()
    if dampening-candidates.len() == 0 {
      [Safe: #line\ ]
      safe += 1
      continue
    } else {
      [#line needs to be dampened\ ]
      [Candidates: #dampening-candidates\ ]
    }
    for candidate in dampening-candidates {
      if not conflicts.all(cs => cs.contains(candidate)) {
        [Can't dampen with #candidate: conflicts remain\ ]
        continue
      }
      if not vees.all(cs => cs.contains(candidate)) {
        [Can't dampen with #candidate: vees remain\ ]
        continue
      }
      let line = line
      let dampened-line = line.remove(candidate)
      let (vees, conflicts) = issues(line)
      if vees == () and conflicts == () {
        [Successfully dampened by removing #candidate\ ]
        safe += 1
        break
      } else {
        [Removing #candidate didn't work\ ]
      }
    }
  }
  aot.answer(safe)
})

