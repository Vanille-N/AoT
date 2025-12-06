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

#let apply(doc) = {
  set page(fill: palette.background)

  set text(size: 13pt, fill: palette.text, font: "Source Code Pro")

  show title: tt => {
    set text(fill: palette.bright, size: 25pt)
    show: align.with(center)
    tt
  }

  show strong: set text(fill: palette.bright)

  show emph: tt => text(fill: palette.color, tt.body)

  show heading.where(level: 3): tt => place(hide(tt))
  show heading: strong

  show raw.where(lang: "ok"): set text(fill: palette.blue)
  show raw.where(lang: "err"): set text(fill: palette.red)
  show raw.where(lang: "unk"): set text(fill: palette.yellow)
  show box: bb => {
    let thickness = if type(bb.stroke) == stroke {
      bb.stroke.thickness
    } else if type(bb.stroke) == dictionary {
      if "thickness" in bb.stroke {
        bb.stroke.thickness
      } else {
        1pt
      }
    } else {
      panic(bb.stroke)
    }
    if thickness > 2pt {
      set box(stroke: palette.bright)
      set box(fill: palette.dimmed)
      bb
    } else if thickness > 1pt {
      set box(stroke: palette.color)
      set box(fill: palette.dimmed)
      bb
    } else {
      bb
    }
  }

  doc
}

#let christmas-tree = [
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
