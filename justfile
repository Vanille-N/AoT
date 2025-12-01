typstc cmd in out +args:
  typst {{cmd}} --root=. --font-path=fonts {{in}}.typ {{out}}.pdf {{args}}

expand cmd year day:
  just typstc {{cmd}} solutions/{{year}}/{{day}} build \
    --input year={{year}} \
    --input day={{day}} \
    --input data="/input/{{year}}/{{day}}/real.txt" \
    --input dummy="/input/{{year}}/{{day}}/dummy.txt" \
    --input source="/solutions/{{year}}/{{day}}.typ"


build year day:
  just expand build {{year}} {{day}}

watch year day:
  just expand watch {{year}} {{day}}

init year day:
  mkdir -p input/{{year}}/{{day}}
  touch input/{{year}}/{{day}}/real.txt
  touch input/{{year}}/{{day}}/dummy.txt
  mkdir -p solutions/{{year}}
  cp solutions/init.typ solutions/{{year}}/{{day}}.typ

edit year day:
  nvim solutions/{{year}}/{{day}}.typ

data year day:
  nvim input/{{year}}/{{day}}/real.txt

dummy year day:
  nvim input/{{year}}/{{day}}/dummy.txt


year-day cmd year day:
  just {{cmd}} {{year}} {{day}}

day cmd day:
  just year-day {{cmd}} $(cat .year) {{day}}

latest cmd:
  just day {{cmd}} $(cat .day)

