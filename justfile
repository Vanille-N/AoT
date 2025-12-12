_typstc cmd in out +args:
  typst {{cmd}} --root=. --font-path=fonts {{in}}.typ {{out}}.pdf {{args}}

_expand cmd year day:
  just _typstc {{cmd}} solutions/{{year}}/{{day}} build \
    --input year={{year}} \
    --input day={{day}} \
    --input data="/input/{{year}}/{{day}}/real.txt" \
    --input dummy-1="/input/{{year}}/{{day}}/dummy-1.txt" \
    --input dummy-2="/input/{{year}}/{{day}}/dummy-2.txt" \
    --input source="/solutions/{{year}}/{{day}}.typ"

_build year day:
  just _expand compile {{year}} {{day}}
  cp build.pdf archive/{{year}}-{{day}}.pdf

_watch year day:
  just _expand watch {{year}} {{day}}

_init year day:
  mkdir -p input/{{year}}/{{day}}
  touch input/{{year}}/{{day}}/real.txt
  touch input/{{year}}/{{day}}/dummy-1.txt
  touch input/{{year}}/{{day}}/dummy-2.txt
  mkdir -p solutions/{{year}}
  cp solutions/init.typ solutions/{{year}}/{{day}}.typ

_edit year day:
  nvim solutions/{{year}}/{{day}}.typ

_data year day:
  nvim input/{{year}}/{{day}}/real.txt

_dummy year day:
  nvim input/{{year}}/{{day}}/dummy-1.txt
  cp input/{{year}}/{{day}}/dummy-{1,2}.txt

_dummy2 year day:
  nvim input/{{year}}/{{day}}/dummy-2.txt

year-day cmd year day:
  just {{cmd}} {{year}} {{day}}

day cmd day:
  just year-day {{cmd}} $(cat .year) {{day}}

latest cmd:
  just day {{cmd}} $(cat .day)

# Surface layer

build:
  just latest _build

watch:
  just latest _watch

init:
  just latest _init

edit:
  just latest _edit

data:
  just latest _data

dummy:
  just latest _dummy

dummy2:
  just latest _dummy2

today:
  date +%Y > .year
  date +%d > .day
