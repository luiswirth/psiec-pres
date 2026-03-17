#import "@preview/touying:0.6.3": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "math.typ": *
#import "graphics.typ": *
#show: math-template

#let fgcolor = white
#let bgcolor = black
#let accent  = rgb("#5ba4d4")
#let accent2 = rgb("#e07b4f")

#set text(font: "New Computer Modern Sans")
#set text(size: 22pt)
#set text(fill: fgcolor)

#show: touying-slides.with(
  config-page(
    paper: "presentation-16-9",
    fill: bgcolor,
    margin: 1.5cm,
  ),
  config-common(
    slide-fn: slide,
  ),
)

#let diagram = fletcher.diagram.with(
  node-fill: black,
  edge-stroke: white,
  crossing-fill: black,
)

#show heading.where(level: 1): set text(35pt)
#show heading.where(level: 1): set block(spacing: 10pt)

#let weblink(..args) = text(fill: blue, link(..args))

#let snote(content) = [#set text(20pt); #content]

#let defbox(title: none, body) = block(
  width: 100%, inset: 12pt, radius: 4pt,
  fill: rgb("#0a1e30"),
  stroke: (left: 3pt + accent),
)[
  #if title != none { text(fill: accent, weight: "bold")[#title\ ] }
  #body
]

#let propbox(title: none, body) = block(
  width: 100%, inset: 12pt, radius: 4pt,
  fill: rgb("#1a1200"),
  stroke: (left: 3pt + accent2),
)[
  #if title != none { text(fill: accent2, weight: "bold")[#title\ ] }
  #body
]

#slide[
  #set align(center)
  #box(
    fill: black.transparentize(20%),
    outset: 20pt,
    radius: 0pt,
  )[
    #set align(center)
    #[
      #set text(size: 35pt, weight: "bold")
      #set par(spacing: 5mm)
      $Psi$ec: A local spectral exterior calculus
      \
      2020
    ]
    #v(1cm)
    #[
      #set text(size: 20pt)
      #text(25pt)[#smallcaps[Christian Lessig]]\
      Otto-von-Guericke-Universitaet\
      #weblink("mailto:christian.lessig@ovgu.de")
    ]
    #v(3cm)
    Presented by #smallcaps[Luis Wirth]\
    #weblink("luwirth@ethz.ch")\
    #weblink("lwirth.com")
  ]
]

#slide[
  = Exterior Calculus + Fourier Transform
  #snote[Another presentation about Differential Forms #emoji.face.weary]

  #set align(center + horizon)
  #image("supremacy.png", height: 75%)
]

#slide[
  = Vector Calculus is everywhere
  #v(0.5cm)

  #set text(18pt)

  #grid(columns: (1fr, 1fr), gutter: 20pt,
    defbox(title: [Maxwell's Equations])[
      $
        div avec(E) &= rho / epsilon_0 \
        div avec(B) &= 0 \
        curl avec(E) &= -(partial avec(B))/(partial t) \
        curl avec(B) &= mu_0 avec(J) + mu_0 epsilon_0 (partial avec(E))/(partial t) \
      $
    ],
    defbox(title: [Linear Elasticity])[
      $
        div tens(sigma) + avec(f) = rho (partial^2 avec(u))/(partial t^2)
        \
        tens(epsilon) = 1/2 (grad avec(u) + (grad avec(u))^tp)
      $
    ]
  )

  #defbox(title: [Navier-Stokes (incompressible)])[
    $
      (partial avec(u))/(partial t) + (avec(u) dot.op grad) avec(u)
      =
      -1/rho grad p + nu lapl avec(u) + avec(f)
      #h(3cm)
      div avec(u) = 0
    $
  ]
]

#slide[
  = Structural Identities
  #snote[The nature of PDEs]

  #text(40pt)[
    $
      curl compose grad = 0
      quad quad
      div compose curl = 0
    $
  ]
  
  - Violate Structural Identities $->$ Numerical Scheme breakes!
    - Spurious Solutions
    - Unphysical Fields
    - Magnetic Monopoles

]

#slide[
  = The de Rham Complex
  #snote[Connecting the Differentials]
  #v(1cm)

  #text(30pt)[
    $
      H(grad; Omega) limits(->)^grad Hvec (curl; Omega) limits(->)^curl Hvec (div; Omega) limits(->)^div L^2(Omega)
      \
      curl compose grad = 0
      quad quad
      div compose curl = 0
    $
  ]
]

#slide[
  = The Discretization Frameworks
  #snote[Structure Preservation is key!]

  #v(0.4cm)

  #grid(columns: (1fr, 1fr), gutter: 14pt,
    defbox(title: "FEEC / DEC")[
      - Mesh-based
      - Continous forms are replaced by *discrete surrogates* (cochains)
      - Structure preservation must be *carefully constructed*
    ],
    propbox(title: [$Psi$ec])[
      - Mesh-free
      - Basis functions are *genuine continuous forms*
      - Structure preservation is *automatic*.
      //- Spectral method in the frequency domain
    ],
  )
]

#slide[
  = The de Rham Complex
  #snote[Everything is a Differential Form]
  #v(1cm)

  #set text(30pt)
  $
    H(grad; Omega) limits(->)^grad Hvec (curl; Omega) limits(->)^curl Hvec (div; Omega) limits(->)^div L^2(Omega)
    \
    curl compose grad = 0
    quad quad
    div compose curl = 0
  $

  #v(1cm)
  
  $
    H Lambda^0 (Omega) limits(->)^dif H Lambda^1 (Omega) limits(->)^dif H Lambda^2 limits(->)^dif H Lambda^3 (Omega)
    \
    dif^2 = dif compose dif = 0
  $
]

#slide[
  = What is a Differential Form?
  #v(0.4cm)

  Differential $k$-form $omega in Lambda^k (Omega)$ is a $k$-dimensional *integrand*!
  \
  Encodes *orientation* and *antisymmetry*.

  #let this(content) = text(fill: blue.lighten(20%), content)
  #let that(content) = text(fill: red, content)
  $
    sans("point/scalar"): quad
    alpha &=
    this(x^3 - 5 x^2 + 4)
    quad
    &in Lambda^0 (Omega)
    \
    sans("curve/circulation"): quad
    beta &=
    this(3 sin(x)) thin that(dif x) + this(e^(x y)) thin that(dif y) + this(log(z)) that(dif z)
    quad
    &in Lambda^1 (Omega)
    \
    sans("surface/flux"): quad
    gamma &=
    this(5) thin that(dif x wedge dif y) + this(2) thin that(dif x wedge dif z) + this(2) thin that(dif y wedge dif z)
    quad
    &in Lambda^2 (Omega)
    \
    sans("volume/density"): quad
    delta &=
    this(cos(x y)) thin that(dif x wedge dif y wedge dif z)
    quad
    &in Lambda^3 (Omega)
  $

  Unifies integration over $k$-dimensional submanifold $M subset.eq Omega$.
  $
    integral_M omega
    quad quad
    dim(M) = that(k) quad omega in Lambda^that(k) (Omega)
  $
]

#slide[
  = The Exterior Derivative
  #snote[One derivative to rule them all.]

  #set text(40pt)
  #set align(horizon + center)

  #let mark(a) = text(red, a)
  
  #grid(
    columns: (50%, 50%),
    align: horizon,
    $
      dif_mark(k): H Lambda^mark(k) -> H Lambda^(k+1)
      \
      dif^2 = dif compose dif = 0
      
    $,
    $
      grad f &= (dif_mark(0) f)^sharp
      \
      curl avec(u) &= (hodge dif_mark(1) avec(u)^flat)^sharp
      \
      div avec(u) &= hodge dif_mark(2) hodge avec(u)^flat
    $,
  )
]

#slide[
  = Differential and Codifferential
  #v(1cm)

  #grid(
    columns: (50%, 50%),
    align: center+ horizon,
    [

  Codifferential
  $
    delta: Lambda^k (Omega) -> Lambda^(k-1) (Omega)
  $

  Defined as $L^2$-adjoint
  $
    delta := dif^*
    \
    ip(dif alpha, beta)_(L^2) = ip(alpha, delta beta)_(L^2)
  $
    ],
    [
      #set align(center)
      #table(
        stroke: fgcolor,
        align: center + horizon,
        inset: 10pt,
        columns: 2,
        table.header($dif$, $delta$),
        table.hline(stroke: 3pt),
        $grad$, $-div$,
        $curl$, $curl$,
        $div$,  $-grad$,
      )
    ],
  )

  Together build the Hodge-Laplacian
  $
    lapl = dif delta + delta dif
  $
]


#slide[
  = Hodge-Helmholtz Decomposition
  #snote[on trivial topologies]
  #v(0.5cm)

  Every $k$-form splits as
  #set text(30pt)
  $
    omega = underbrace(dif alpha, "exact") +
    underbrace(delta beta, "coexact")
  $

  
  #grid(columns: (1fr, 1fr), gutter: 14pt,
    propbox(title: "Exact")[
      $exists beta: dif beta = alpha$ \
      #snote[image of $dif$]
    ],
    propbox(title: "Coexact")[
      $exists beta: delta beta = alpha$ \
      #snote[image of $delta$]
    ],
  )
]

#slide[
  = Helmholtz Decomposition of Vector Fields
  #v(1cm)

  #align(center,
    grid(
      columns: 5,
      gutter: 8pt,
      row-gutter: 20pt,
      align: center + horizon,
      [*Mixed*],
      [],
      [*$curl$-free (exact)*],
      [],
      [*$div$-free (coexact)*],
      flow-svg(spiral-curves, col: "hsl(140,70%,50%)"),
      text(size: 24pt)[$=$],
      flow-svg(source-curves, col: "hsl(210,80%,60%)"),
      text(size: 24pt)[$+$],
      flow-svg(vortex-curves, col: "hsl(0,75%,60%)"),
      $[x-y, x+y]$,
      [],
      $[x,y]$,
      [],
      $[-y,x]$,
    )
  )
]

#slide[
  = The Fourier Transform
  #v(1cm)

  The scalar Fourier transform turns $dif\/dif x$ into multiplication by $i xi$.\
  $->$ Turns differentials equations into algebraic equations!

  Does this also happen in higher dimensions?
]


#slide[
  = Vector Calculus becomes Vector Algebra
  #snote[in the Frequency Domain]
  #v(0.3cm)

  #set text(40pt)
  $
    grad f       &= nabla f       quad &&|-> quad i xi hat(f) \
    curl avec(u) &= nabla times u quad &&|-> quad i xi times hat(avec(u)) \
    div  avec(u) &= nabla dot u   quad &&|-> quad i xi dot hat(avec(u)) \
  $
]

#slide[
  = Exterior Calculus becomes Exterior Algebra
  #snote[in the Frequency Domain]
  #v(0.3cm)


  #text(40pt)[
  $
    dif omega   quad &|-> quad iota_(i xi) thin hat(omega) \
    delta omega quad &|-> quad i xi wedge hat(omega) \
  $
  ]
  where
  - $iota_(i xi)$ is the *interior product* (contraction) with $i xi$
  - $i xi wedge dot$ is the *wedge product* (extension) with $i xi$
]


#slide[
  = The Spherical Geometry of Derivatives
  #snote[in the Frequency Domain]

  Write the frequency vector in spherical coordinates:
  $
    xi = abs(xi) dif hat(r)
  $
  where $hat(r)$ is the unit radial frequency basis. Then:
  $
    hat(dif) hat(omega) &= i abs(xi) thin iota_(partial\/partial hat(r)) thin hat(omega)
    \
    hat(delta) hat(omega) &= i abs(xi) thin partial\/partial hat(r) wedge hat(omega)
  $
  Both operators factor into a scalar part $i|xi|$ and a purely geometric part
  that acts only in the *radial direction*.
]


#slide[
  = To be, or not to be radial
  #v(1cm)

  #let madd(a) = text(fill: green, a)
  #let mrm(a) = text(fill: red, a)

  - The contraction $iota_(partial\/partial hat(r))$ strips off the radial
    component $partial slash partial hat(r)$ from a form.
    $
      hat(omega)_(r theta) thin mrm(partial\/partial hat(r) wedge) partial\/partial hat(theta)
      quad |->^hat(dif) quad
      hat(omega)_(r theta) thin partial\/partial hat(theta)
    $
  - The wedge $partial\/partial hat(r) and$ attaches a radial component.
    $
      hat(omega)_theta thin partial\/partial hat(theta)
      quad |->^hat(delta) quad
      hat(omega)_theta thin madd(partial\/partial hat(r) wedge) partial\/partial hat(theta)
    $

  #propbox(title: "Magic")[
    All of multidimensional calculus just becomes adding and removing radial components!
  ]
]

#slide[
  = Trivial Differentials
  #v(1cm)
  You cannot remove a radial component twice.
  $
    hat(dif) compose hat(dif) = iota_(partial\/partial hat(r)) thin iota_(partial\/partial hat(r)) =  0
  $

  You cannot wedge on a second radial component by antisymmetry.
  $
    hat(delta) compose hat(delta) = partial\/partial hat(r) wedge partial\/partial hat(r) = 0
  $

  Geometric parts compose to identity, leaving only a scalar.
  $
    hat(lapl) = hat(dif) hat(delta) + hat(delta) hat(dif) = abs(xi)^2
  $
]

#slide[
  = Trivial Hodge-Helmholtz Decomposition
  #snote[via Fourier]
  #v(0.5cm)

  Hodge-Helmholtz becomes basic geometric fact.

  All forms split into two orthogonal types:
  - *Tangential/Exact forms* $hat(omega)_dif$
  - *Radial/Coexact forms* $hat(omega)_delta$

  The differentials move between them:
  $
    hat(dif): "radial" arrow.r^(iota _(partial slash partial hat(r))) "tangential"
    \
    hat(delta): "tangential" arrow.r^(hat(r) and) "radial"
  $
]

#slide[
  = Spectral exterior calculus to solve PDEs
  #v(1cm)

  Numerical methods?
  $->$ We need to construct basis functions!

  Requirements:
  - meshless
  - continuous basis functions $b in C^infinity$

  #propbox(title: "A first idea")[
    Inspired by Fourier: Use plane waves in space.
    $
      b(x) = e^(i xi_0 x) = cos(xi_0 x) + i sin(xi_0 x)
    $
    $->$ classical spectral method.
  ]
  
]

#slide[
  = The Localization Tradeoff
  #snote[Position vs Frequency]

  #v(0.2cm)

  #grid(columns: (1fr, 1fr), gutter: 14pt,
    defbox(title: "Plane wave — perfect frequency")[
      $e^(i xi_0 x) quad arrows.lr quad delta(xi - xi_0)$\
      #emoji.crossmark Zero position localization. \
      Classical spectral method.
    ],
    uncover("2-", defbox(title: "Dirac delta — perfect position")[
      $delta(x - x_0) quad arrows.lr quad e^(i x_0 xi)$\
      #emoji.crossmark Zero frequency localization. \
      Spirit of finite elements.
    ]),
  )

  #v(0.2cm)

  #uncover(3, propbox(title: "Heisenberg Uncertainty Principle")[
    Any function occupies a region of area $>= 1/2$ in the position $times$ frequency space.
    $
      Delta x Delta xi >= 1/2
    $
  ])
]

#slide[
  = Strike a Balance
  #v(0.5cm)

  Need localization in *both*. \
  $->$ Handle global/periodic and local/singular phenomenon alike.

  #pause

  #v(1cm)
  = The Gaussian
  #v(0.1cm)

  #grid(
    columns: (1fr, 1fr),
    [
      - Same localization in both domains,\
       minimal uncertainty overall.
    
        $
          Delta x Delta xi = 1/sqrt(2) 1/sqrt(2) = 1/2
        $
      - Fourier self-dual.
        $
          e^(-x^2\/2) arrows.lr e^(-xi^2\/2)
        $
    ],
    [
      #set align(center + horizon)
      #wavelet-plot(gaussian, width: 400pt, col: yellow.lighten(10%), ymin: -0.5, ymax: 1.1)
    ],
  )

]

#slide[
  = Wavelets
  #snote[Functions localized in both space and frequency]
  #v(0.3cm)

  #figure(grid(
    columns: 3,
    gutter: 14pt,
    align: center,
    [
      *Haar*\
      #wavelet-plot(haar, xmin: -1.5, xmax: 2.5)
    ],
    [
      *Mexican Hat*\
      #wavelet-plot(mexican-hat, col: red.lighten(20%))
    ],
    [
      *Morlet*\
      #wavelet-plot(morlet, col: green.lighten(20%))
    ],
  ))

  Wavelets can be scaled and translated.
  - large scale + narrow in frequency $->$ smooth/periodic phenomena
  - small scale + wide in frequency $->$ sharp/singular phenomena
]

#slide[
  = Polar Wavelets
  #v(0.3cm)

  Exterior Calculus is spherical in frequency space.\
  $->$ Define wavelets in spherical frequency coordinates $xi = (rho, theta)$
  $
    hat(psi)(rho, theta) = h(rho) dot g(theta)
  $
  - $h(rho)$: radial factor: where $dif$ and $delta$ act
  - $g(theta)$: angular factor: directionality; from isotropic to curvelet

  #v(0.3cm)
  The Hodge decomposition is *built-in*:
  #v(-0.5cm)
  #grid(columns: (1fr, 1fr), gutter: 12pt,
    defbox(title: "Tangential/Exact Wavelets")[
      #set text(35pt)
      #v(-1cm)
      $
        hat(psi)^dif in im(dif)
      $
    ],
    defbox(title: "Radial/Coexact Wavelets")[
      #set text(35pt)
      #v(-1cm)
      $
        hat(psi)^delta in im(delta)
      $
    ],
  )
]

#slide[
  = Differential Form Wavelets
  #v(0.5cm)

  #grid(
    columns: (20%, 80%),
    text(40pt)[
      #set align(center + horizon)
      $
        psi^(k,nu)_s
      $
    ],
    [
      - form degree $k$
      - type $nu in {dif, delta}$
      - geometry $s = (j, k, t)$ — scale, translation, orientation.
    ],
  )

  #v(1cm)
  Wavelets are built with de Rham complex in mind!\
  $->$ Differentials map one wavelet to another. Geometry $s$ unchanged!\
  $->$ Structural Identities elegantly fulfilled.
  #set text(40pt)
  $
    dif psi^(k,delta)_s = psi^(k+1,dif)_s
    quad quad
    dif psi^(k,dif)_s = 0
  $
]

#slide[
  = The Main Message
  #v(0.6cm)

  *multidimensional calculus* $->$ *exterior calculus* $->$ *frequency space* $->$ *spherical coordinates*

  The de Rham complex reduces to adding/removing radial components.

  Polar differential forms wavelets!
]

#slide[
  #set align(center + horizon)
  #set text(size: 90pt)

  The End.
]


#slide[
  = Frequency Space $hat(RR)^n$
  #snote[The dual space of position space]
  #v(0.2cm)

  The Fourier exponential $e^(i x^p xi_p)$ must be coordinate-independent.\
  Under $x^p |-> lambda x^p$ we need $xi_p |-> xi_p \/ lambda$:

  #grid(columns: (1fr, 1fr), gutter: 14pt,
    defbox(title: [$x^p$ contravariant])[
      position, vector, \
      transforms *with* basis change
    ],
    defbox(title: [$xi_p$ covariant])[
      frequency, covector, \
      transforms *against* basis change
    ],
  )

  #propbox(title: "Dual space")[
    $hat(RR)^n = (RR^n)^*$. #h(1em)
    The pairing $chevron.l xi, x chevron.r = xi_p x^p$ is canonical — *no metric required*.
  ]

  $xi$ is a *stack of parallel hyperplanes* (wavefronts of $e^(i xi_p x^p)$).
  The pairing counts how many wavefronts $x$ crosses.
]
#slide[
  = The Fourier Transform Changes Variance
  #snote[Covariant spatial forms become contravariant frequency multivectors]
  #v(0.2cm)

  #grid(columns: (1fr, 1fr), gutter: 14pt,
    defbox(title: "Spatial forms")[
      Built from $dif x^i in T^* RR^n$ \
      *Covariant* — eat tangent vectors
    ],
    defbox(title: "Frequency forms")[
      Built from $partial\/partial xi_i in T hat(RR)^n$ \
      *Contravariant* — eat covectors
    ],
  )

  #v(0.4cm)

  #propbox[
    The Fourier transform is a map between a vector space and its dual.
    In flat $RR^n$ these are identified by the metric, but the distinction is real.
  ]
]

#slide[
  = The Fourier Transform Changes Degree
  #snote[Integration in space becomes point evaluation in frequency]
  #v(0.2cm)

  An $n$-form integrated over $RR^n$ $->$ a $0$-form evaluated at a point. \
  $
    integral_(RR^n) f(x) space dif x^1 wedge dots.c wedge dif x^n
      = (2pi)^(n\/2) hat(f)(0)
  $


  #v(0.3cm)

  #propbox(title: "Degree flip")[
    $
      cal(F) : Lambda^k (RR^n) -> hat(Lambda)^(n-k)(hat(RR)^n)
    $
    The $k$ occupied directions are consumed by integration.
    The remaining $n-k$ become the basis of the output form in frequency.
  ]
]
