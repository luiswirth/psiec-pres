#import "@preview/touying:0.6.3": *
#import "@preview/fletcher:0.5.2" as fletcher: diagram, node, edge
#import "@preview/tiaoma:0.2.1"

#import "math.typ": *
#show: math-template

#let fgcolor = white
#let bgcolor = black

#set text(font: "New Computer Modern Sans")
#set text(size: 23pt)
#set text(fill: fgcolor)

#show: touying-slides.with(
  config-page(
    paper: "presentation-16-9",
    fill: bgcolor,
    margin: (left: 1.5cm, right: 1.5cm, top: 1.0cm, bottom: 0.1cm),
  ),
  config-common(
    slide-fn: slide,
  ),
)

#show heading.where(level: 1): set text(35pt)
#show heading.where(level: 1): set block(spacing: 10pt)


#let weblink(..args) = text(
    fill: blue,
    link(..args)
  )

#let snote(content) = [
  #set text(20pt)
  #content
]

#page(
  //background: image("res/bg-vibrant.jpg", fit: "cover"),
  margin: 2cm,
)[
  #set align(center)
  
  #box(
    fill: white.transparentize(20%),
    outset: 20pt,
    radius: 0pt,
  )[
    #set align(center)
    
    #[
      #set text(size: 35pt, weight: "bold")
      #set par(spacing: 5mm)

      $Psi$ec: A local spectral exterior calculus
    ]

    #[
      #set text(size: 25pt)
      2020
    ]
  
    #[
      #set text(size: 20pt)

      #smallcaps[Christian Lessig]\
      Otto-von-Guericke-Universitaet\
      #weblink("mailto:cristian.lessig@ovgu.de")
    ]

    #v(1cm)
    Presented by #smallcaps[Luis Wirth]\
    #weblink("luwirth@ethz.ch")\
    #weblink("lwirth.com")
  ]
]


#slide[
  = Title
  #snote[Subtitle]

  - Bulletpoint 1
  - Bulletpoint 2
]

