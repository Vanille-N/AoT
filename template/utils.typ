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

