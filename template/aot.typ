#import "utils.typ"
#import "lib.typ"

#import "visuals.typ"
#import visuals: palette

#let _printing = state("printing", true)
#let log-line(msg) = context {
  if _printing.get() {
    if type(msg) == function {
      [#msg() \ ]
    } else {
      [#msg \ ]
    }
  }
}

#let year = int(sys.inputs.year)
#let day = int(sys.inputs.day)

#let _hint = state("hint")
#let hint(val) = _hint.update(_ => val)

#let _answer = state("answer")
#let answer(val) = _answer.update(_ => val)

#let _parser = state("parser")
#let parser(fun) = _parser.update(_ => fun)

#let _display = state("display", d => [#d])
#let printer(fun) = _display.update(_ => fun)
#let print(data) = context {
  if _printing.get() {
    _display.at(label("begin-dummy-0"))(data)
  }
}

#let _draft = state("draft", false)
#let draft() = _draft.update(true)

#let _full-log = state("full-log", false)
#let full-log() = _full-log.update(true)

#let _solve-id = state("solve-id", 0)

#let calendar(year, month, highlight: ()) = {
  let days = ()
  show: align.with(center)
  let start-date = datetime(day: 1, month: month, year: year)
  grid(columns: (1cm, 1fr, 7cm),
    align(bottom, box[
      #show: rotate.with(-90deg, reflow: true)
      #set text(size: 20pt)
      #emph[#{start-date.display("[month repr:long] [year]")}]
    ]),
    box[
      #set text(size: 17pt)
      #let cell(day) = box(
        inset: 5pt,
        width: 100%,
        stroke: if day in highlight { 3pt } else { 1.1pt },
        {
          if day in highlight {
            strong[#day]
          } else {
            emph[#day]
          }
        }
      )
      #grid(columns: 7, gutter: 5pt,
        ..( for i in range(start-date.weekday() - 1) { ([],) } ),
        ..({
          let cur-date = start-date
          while cur-date.month() == start-date.month() {
            (cell(cur-date.day()),)
            cur-date = cur-date + duration(days: 1)
          }
        })
      )
    ],
    visuals.christmas-tree,
  )
}

#let format(doc) = {
  show: visuals.apply

  set document(
    title: [Advent of Code],
  )

  title()
  calendar(year, 12, highlight: (day,))

  [= Answers]

  context {
    for id in range(_solve-id.final()) {
      let label-dummy = label("end-dummy-" + str(id))
      [== Part #{id + 1}]
      grid(columns: (1fr,), [
        #show: block.with(width: 100%, stroke: palette.dimmed, inset: 10pt)
        #let expected = _hint.at(label-dummy)
        #let computed = _answer.at(label-dummy)
        Executed on the #emph[example input]. \
        - Expected answer: #{if expected != none { strong[#expected] } else { [```unk ?```] }}
        - Computed answer: #{if computed != none { strong[#computed] } else { [```unk ?```] }}
        #{
          if expected == none or computed == none {
            [Data is ```unk incomplete```]
          } else if expected == computed {
            [This seems ```ok correct```]
          } else {
            [This seems ```err incorrect```]
          }
        }

        #line(end: (100%,0%), stroke: palette.dimmed)

        #let computed = _answer.at(label("end-real-" + str(id)))
        Executed on the #emph[evaluation input]. \
        - Computed answer: #{if computed != none { strong[#computed] } else { [```unk ?```] }}
      ])
    }
  }

  pagebreak()
  [= Logs]

  show heading.where(level: 1): tt => {
    _hint.update(none)
    _answer.update(none)
    _draft.update(false)
    _full-log.update(false)
    tt
  }
  show heading.where(level: 2): set text(fill: palette.yellow)
  {
    [== Parsing ]
    show: block.with(width: 100%, stroke: palette.dimmed, inset: 5pt)
    context {
      let parser = _parser.at(label("begin-dummy-0"))
      if type(parser) == function {
        let seen = ()
        for (idx, (key, file)) in sys.inputs.pairs().filter(((key,_),) => key.contains("dummy")).enumerate() {
          [== Part #{idx + 1}]
          if key.contains("dummy") {
            let text = read(file)
            if text in seen {
              [(Same)]
              continue
            } else {
              seen.push(text)
            }
            let data = parser(text)
            print(data)
          }
        }
      } else {
        [(No parser specified yet.)]
      }
    }
  }

  doc

  pagebreak()
  [= Source code]

  context {
    for id in range(-1, _solve-id.final()) {
      let label-dummy = label("end-dummy-" + str(id))
      if id >= 0 {
        [#[== Part #{id + 1}] #label("code-" + str(id))]
      } else {
        [== Preliminaries]
      }
      show: block.with(width: 100%, stroke: palette.dimmed, inset: 10pt)
      [
        #let full = read(sys.inputs.source).split("\n=\n").at(id + 1).trim("\n")
        #let filtered = ()
        #{
          let take = true
          for ln in full.split("\n") {
            if ln.contains("//!>") {
              take = false
            } else if ln.contains("//<!") {
              take = true
            } else if ln.contains("aot.log-line") {
            } else if ln.contains("aot.hint") {
            } else if ln.contains("//!!") {
            } else if ln.contains("//!") {
              filtered.push(ln.split("//!").at(0))
            } else {
              filtered.push(ln)
            } 
          }
        }
        #raw(block: true, lang: "typ", filtered.join("\n").trim("\n").replace(regex("\n\n+"), "\n\n"))
      ]
    }
  }
}

#let solve(fun) = context {
  let id = _solve-id.get()
  [== Part #{id + 1}]
  _solve-id.update(n => n + 1)
  show: block.with(width: 100%, stroke: palette.dimmed, inset: 5pt)
  [=== begin #label("begin-dummy-" + str(id))]
  context {
    let parser = _parser.get()
    let data = parser(read(sys.inputs.at("dummy-" + str(id + 1), default: "dummy")))
    fun(data)
  }
  [=== end #label("end-dummy-" + str(id))]
  [=== begin #label("begin-real-" + str(id))]
  _answer.update(none)
  context {
    if _draft.get() [
      Final computation skipped.
      Remove #emph[draft] mode to enable.
    ] else {
      context {
        let parser = _parser.get()
        let data = parser(read(sys.inputs.data))
        if _full-log.get() {
          [#fun(data)]
        } else {
          place(hide({
            _printing.update(false)
            [#fun(data)]
            _printing.update(true)
          }))
        }
      }
    }
  }
  [=== end #label("end-real-" + str(id))]
}

