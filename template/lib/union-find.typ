#let init(nb) = {
  (repr: range(nb))
}

#let class-of(universe, elt) = {
  let repr = universe.repr.at(elt)
  if repr == elt {
    (universe, repr)
  } else {
    let (universe, ans) = class-of(universe, repr)
    universe.repr.at(elt) = ans
    (universe, ans)
  }
}

#let unify(universe, elt1, elt2) = {
  let (universe, repr1) = class-of(universe, elt1)
  let (universe, repr2) = class-of(universe, elt2)
  if repr1 == repr2 {
    (universe, false)
  } else {
    universe.repr.at(repr2) = repr1
    (universe, true)
  }
}

#let classes(universe) = {
  let cls = (:)
  for elt in range(universe.repr.len()) {
    let (u, repr) = class-of(universe, elt)
    universe = u
    if str(repr) in cls {
      cls.at(str(repr)).push(elt)
    } else {
      cls.insert(str(repr), (elt,))
    }
  }
  cls.values()
}

