#let _bisorted(intervals) = {
  let starts = intervals.sorted(key: intv => intv.at(0))
  let ends = intervals.sorted(key: intv => intv.at(1))
  (starts: starts, ends: ends)
}

#let build(intervals) = {
  if intervals.len() == 0 {
    return (root: none)
  }
  let (lo, hi) = intervals.fold((none, none), ((lo, hi), (a, b)) => {
    if lo == none or a < lo { lo = a }
    if hi == none or b > hi { hi = b }
    (lo, hi)
  })
  let mid = int((lo + hi) / 2)
  let below = ()
  let above = ()
  let touch = ()
  for (a, b) in intervals {
    if mid < a {
      above.push((a, b))
    } else if b < mid {
      below.push((a, b))
    } else {
      touch.push((a, b))
    }
  }
  (root: mid, below: build(below), above: build(above), touch: _bisorted(touch))
}

#let print(tree) = {
  [#tree]
}

#let _query-starts(starts, point) = {
  let lo = -1
  let hi = starts.len()
  while true {
    if lo + 1 >= hi {
      return starts.slice(0, lo + 1)
    }
    let mid = int((lo + hi) / 2)
    if starts.at(mid).at(0) <= point {
      lo = mid
    } else {
      hi = mid
    }
  }
}

#let _query-ends(ends, point) = {
  let lo = -1
  let hi = ends.len()
  while true {
    if lo + 1 >= hi {
      return ends.slice(hi)
    }
    let mid = int((lo + hi) / 2)
    if ends.at(mid).at(1) < point {
      lo = mid
    } else {
      hi = mid
    }
  }
}

#let overlap(tree, point) = {
  let out = ()
  while true {
    if tree.root == none { break }
    if point < tree.root {
      out += _query-starts(tree.touch.starts, point)
      tree = tree.below
    } else if point > tree.root {
      out += _query-ends(tree.touch.ends, point)
      tree = tree.above
    } else {
      // point == tree.root
      out += tree.touch.starts
      break
    }
  }
  out
}

