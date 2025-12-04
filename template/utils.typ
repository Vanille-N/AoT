#let unzip2(ll) = {
  let l = ()
  let r = ()
  for (a, b) in ll {
    l.push(a)
    r.push(b)
  }
  (l, r)
}

#let frequency(arr, key: repr) = {
  let fs = (:)
  for e in arr {
    let key = key(e)
    fs.insert(key, fs.at(key, default: 0) + 1)
  }
  fs
}

#let divisors(n) = {
  let divs = (1, n)
  let d = 2
  while d * d <= n {
    if calc.rem(n, d) == 0 {
      divs.push(d)
      divs.push(int(n / d))
    }
    d += 1
  }
  divs.sorted().dedup()
}

#let argmax(arr) = {
  let best = none
  let idx = none
  for (i, elt) in arr.enumerate() {
    if best == none or elt > best {
      best = elt
      idx = i
    }
  }
  idx
}
