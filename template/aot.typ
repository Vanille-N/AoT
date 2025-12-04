#import "utils.typ"

#let palette = (
  background: rgb("0F0F23"),
  text: rgb("A8B7A5"),
  dimmed: rgb("2D2D30"),
  color: rgb("047F0E"),
  bright: rgb("8BCD6A"),

  red: red.lighten(10%),
  blue: blue.lighten(60%),
  yellow: yellow.darken(20%),
)

#let year = int(sys.inputs.year)
#let day = int(sys.inputs.day)

#let _hint = state("hint")
#let hint(val) = _hint.update(_ => val)

#let _answer = state("answer")
#let answer(val) = _answer.update(_ => val)

#let _parser = state("parser")
#let parser(fun) = _parser.update(_ => fun)

#let _testing = state("testing", true)
#let _display = state("display", d => [#d])
#let printer(fun) = _display.update(_ => fun)
#let print(data) = context {
  if _testing.get() {
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
      #set text(size: 20pt, fill: palette.color)
      #emph[#{start-date.display("[month repr:long] [year]")}]
    ]),
    box[
      #set text(size: 17pt)
      #let cell(day) = {
        box(
          inset: 5pt,
          width: 100%,
          stroke: if day in highlight { palette.bright + 3pt } else { palette.color + 1pt },
          fill: if day in highlight { palette.dimmed } else { palette.dimmed },
        )[
          #{
            if day in highlight {
              strong[#day]
            } else {
              emph[#day]
            }
          }
        ]
      }
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
    [
      // Art from: https://delightlylinux.wordpress.com/2021/12/23/a-simple-ascii-christmas-tree-in-bash/
      #let art = ```
          *
         /.\
        /o..\
        /..o\
       /.o..o\
       /...o.\
      /..o....\
      ^^^[_]^^^
      ```
      #set text(size: 20pt)
      #set par(leading: 0.4em)
      #show "*": set text(fill: palette.yellow)
      #let _decoration-parity = state("decoration-parity", 0)
      #show "o": {
        context {
          let color = if calc.rem(_decoration-parity.get(), 2) == 0 {
            palette.red
          } else {
            palette.blue
          }
          text(fill: color)[#h(1pt)`o`#h(1pt)]
          _decoration-parity.update(x => x + 1)
        }
      }
      #show "[_]": set text(fill: yellow.darken(50%))
      #show regex("\\\\|\\.|\\/|\\^"): set text(fill: palette.color)
      #link("https://adventofcode.com/2024/day/2")[#art]
    ]
  )
}

#let format(doc) = {
  set text(size: 13pt, fill: palette.text, font: "Source Code Pro")
  show strong: set text(fill: palette.bright)
  show emph: tt => text(fill: palette.color, tt.body)

  set document(
    title: {
      set text(size: 25pt)
      set text(fill: palette.bright)
      [#h(1fr) Advent of Code #h(1fr)]
    },
  )
  set page(fill: palette.background)

  title()
  calendar(year, 12, highlight: (day,))

  show heading.where(level: 3): tt => place(hide(tt))
  show heading: strong

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
        - Expected answer: #{if expected != none { strong[#expected] } else { [_?_] }}
        - Computed answer: #{if computed != none { strong[#computed] } else { [_?_] }}
        #{
          if expected == none or computed == none {
            [Data is #text(fill: palette.yellow)[incomplete]]
          } else if expected == computed {
            [This seems #text(fill: palette.blue)[correct]]
          } else {
            [This seems #text(fill: palette.red)[incorrect]]
          }
        }

        #line(end: (100%,0%), stroke: palette.dimmed)

        #let computed = _answer.at(label("end-real-" + str(id)))
        Executed on the #emph[evaluation input]. \
        - Computed answer: #{if computed != none { strong[#computed] } else { [_?_] }}
      ]
      )
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
        let data = parser(read(sys.inputs.dummy))
        print(data)
      } else {
        text(fill: palette.text)[(No parser specified yet.)]
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
        #raw(block: true, lang: "typ", full)
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
    let data = parser(read(sys.inputs.dummy))
    fun(data)
  }
  [=== end #label("end-dummy-" + str(id))]
  [=== begin #label("begin-real-" + str(id))]
  _testing.update(false)
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
          place(hide[#fun(data)])
        }
      }
    }
  }
  _testing.update(true)
  [=== end #label("end-real-" + str(id))]
}

