#import "@preview/touying:0.6.3": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "math.typ": *
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

#page(
  margin: 2cm,
)[
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
    ]
    #[#set text(size: 25pt); 2020]
    #[
      #set text(size: 20pt)
      #smallcaps[Christian Lessig]\
      Otto-von-Guericke-Universitaet\
      #weblink("mailto:christian.lessig@ovgu.de")
    ]
    #v(1cm)
    Presented by #smallcaps[Luis Wirth]\
    #weblink("luwirth@ethz.ch")\
    #weblink("lwirth.com")
  ]
]

#slide[
  = Local Spectral Exterior Calculus
  #snote[Another Presentation on Differential Forms]

  Main Idea:
  Use Exterior Calculus of Differential Forms to solve PDEs numerically. \
  $->$ Discretization Frameworks

  Exterior Calculus Frameworks:
  + Discrete Exterior Calculus (DEC) [1st order FEEC w/o $L^2$ Hodge mass matrix]
  + Finite Element Exterior Calculus (FEEC)
  + Local Spectral Exterior Calculus ($Psi$ec)

]

#slide[
  = Local Spectral Exterior Calculus
  #snote[What's different now?]

  - FEEC and DEC are mesh-based.
  - $Psi$ec is mesh-free.
  - For FEEC and DEC we need to construct discrete couterparts (cochains + Whitney forms), that are structure-preserving $->$ difficult.
  - $Psi$ec doesn't use discretized variants, but genuine continous forms themself. Of course structure-preserving $->$ free.


]

#slide[
  = Differential Forms

  #snote[An $r$-form is an antisymmetric covariant tensor field of rank $r$]

  #v(0.3cm)

  #defbox(title: [Differential $r$-form ] + $alpha in Omega(r)(RR^n)$)[
    $
      alpha(x) = sum_(j_1 < dots.c < j_r) alpha_(j_1 dots j_r)(x)
        space dif x^(j_1) wedge dots.c wedge dif x^(j_r)
    $
  ]

  #v(0.4cm)

  In $RR^3$, the four spaces of forms are:

  #grid(columns: (1fr, 1fr), gutter: 12pt,
    defbox[point fields $1_x in Omega(0)$],
    defbox[line fields $dif x^i in Omega(1)$],
    defbox[area fields $dif x^i wedge dif x^j in Omega(2)$],
    defbox[volume fields $dif x^i wedge dif x^j wedge dif x^k in Omega(3)$],
  )

  #v(0.3cm)

  #snote[
    Exterior derivative $dif : Omega(r) -> Omega(r+1)$,
    coordinate-free generalisation of $grad$, $curl$, $div$.
    Satisfies $dif compose dif = 0$.
  ]
]

#slide[
  = The de Rham Complex

  #snote[$dif compose dif = 0$ turns the spaces of forms into a co-chain complex]

  #v(0.5cm)

  #align(center)[
    #defbox[
      $
        0 arrow.r Omega(0)(RR^n)
          arrow.r^(dif) Omega(1)(RR^n)
          arrow.r^(dif) dots.c
          arrow.r^(dif) Omega(n-1)(RR^n)
          arrow.r^(dif) Omega(n)(RR^n)
          arrow.r 0
      $
    ]
  ]

  #v(0.5cm)

  #grid(columns: (1fr, 1fr), gutter: 14pt,
    propbox[
      *Closed*: $dif alpha = 0$
    ],
    propbox[
      *Exact*: $exists beta: alpha = dif beta$
    ],
  )

  #v(0.4cm)

  #propbox(title: "Goal")[
    Understand the exterior calculus *in the Fourier domain*.\
    Key insight: the structure becomes *geometrically transparent*
    in spherical coordinates in frequency space.
  ]
]

#slide[
  = Fourier Transform of a Differential Form

  #snote[Maps $r$-forms in $x$-space to $(n-r)$-forms in frequency space $hat(RR)^n$]

  #v(0.2cm)

  #defbox[
    For $alpha in Omega(r)(RR^n)$, the Fourier transform
    $hat(alpha) = cal(F)(alpha) in hat(Omega)(n-r)(hat(RR)^n)$ is:
    $
      hat(alpha)(xi)
        = frac(1,(2 pi)^(n\/2))
          sum_(j_1 < dots < j_r)
          integral_(RR^n)
          alpha_(j_1 dots j_r)(x)\,
          dif x^(j_1) wedge dots wedge dif x^(j_r)
          wedge e^(-ii x_p xi_p)
          wedge e^(dif x^q tp partial/(partial xi_q))
    $
    where the *exponential of form basis functions* is:
    $
      e^(dif x^q tprod partial/(partial xi_q))
        = sum_(a=0)^n frac((dif x^q tprod partial/(partial xi_q))^(wedge a), a!)
    $
  ]

  #v(0.3cm)

  #snote[
    The degree shift $r mapsto n - r$ reflects integration–evaluation duality:
    $integral_(RR^n) f(x) dif x = hat(f)(0)$, so a volume form maps to a $0$-form.
  ]
]


#slide[
  = Fourier Transform changes degree

  Volume Integration in space becomes point evaluation in frequency.
  $
    integral_(RR^n) f(x) space dif x^1 wedge dots.c wedge dif x^n = hat(f) (0)
  $

  Point evaluation is integration of a 0-form.
  $
    integral_{x} f = f(x)
  $

  Therefore we should have \
  $cal(F): Omega^n -> Omega^0$ and $cal(F): Omega^0 -> Omega^n$
  and by generalization \
  $cal(F): Omega^r -> Omega^(n-r)$
]

#slide[
  = Frequency space $hat(RR)$

  The Fourier exponential $e^(i x xi)$ becomes $e^(i ip(x, xi)$ in multiple dimensions.
  The Fourier exponential must be coordinate-independent, otherwise Fourier transform would be ill-defined
  and depend on the choice of coordinates. Therefore $ip(dot, dot)$ cannot be an inner-product, since this
  would require a coordiante-dependent metric. Instead it's the canonical dual pairing.
  But of course $x$ is coordinate dependent, it's just the coordinate numbers. So $xi$ needs to cancel
  any coordiante changes exactly in the opposite direction.
  $
    x |-> lambda x \
    xi |-> xi / lambda
  $
  This is captured by the co-/contra-variance of these objects.
  $x$ is contravariant and $xi$ is covariant. They transform in opposite directions.
  $ip(x, xi)$ is therefore a dual pairing and coordiante independent.

  Dual space.
  $
    hat(RR) = RR^*
  $

  Canonical dual pairing.
  $
    ip(dot, dot): hat(RR) times RR -> R, quad ip(xi, x) |-> xi(x)
  $

  $e^(i xi_p x^p)$ is a plane wave. The isosurfaces of constant phase are $xi_p x^p eq.triple "const"$.
  These are the hyperplanes perpendicular to the direction of propagation.
  Covectors are exactly the right object to describe families of hyperplanes.
  The level sets of $xi$ are the wavefronts.

  $x in T_x RR^n$ arrow at a point.
  $xi in T^*_x RR^n$ stack of parallel lines (level sets) with spacing inversily proportional to $abs(xi)$.

  Dual pairing couts how many liens the arrow crosses.
  
]

#slide[
  = Fourier Transform changes Variance

  Spatial Differential Forms are covariant.
  Frequency Differential Forms are contravariant.
]

#slide[
  = FT of the Basis Forms

  #snote[By linearity, the FT is determined by its action on basis forms]

  #v(0.3cm)

  In $RR^3$, with permutation $sigma = mat(1,2,3; j_1,j_2,j_3)$:

  #v(0.2cm)

  #grid(columns: (1fr, 1fr), gutter: 10pt,
    defbox[
      $cal(F)(1_x) = -partial_(xi_1) wedge partial_(xi_2) wedge partial_(xi_3)$
    ],
    defbox[
      $cal(F)(dif x^(j_1)) = -op("sgn")(sigma) partial_(xi^(j_2)) wedge partial_(xi^(j_3))$
    ],
    defbox[
      $cal(F)(dif x^(j_1) wedge dif x^(j_2)) = op("sgn")(sigma) partial_(xi^(j_3))$
    ],
    defbox[
      $cal(F)(dif x^1 wedge dif x^2 wedge dif x^3) = 1_xi$
    ],
  )

  #v(0.3cm)

  #propbox(title: "General formula   (Remark 2)")[
    $
      cal(F)(dif x^(j_1) wedge dots wedge dif x^(j_r))
        = -(-1)^(floor(r\/2)) op("sgn")(sigma)
          space partial_(xi^(sigma_(n-r+1))) wedge dots wedge partial_(xi^(sigma_n))
    $
  ]

  #snote[Structure is analogous to the Hodge dual $hodge$ — compare with $hodge dif x^i$ in $RR^3$.]
]


#slide[
  = FT of Convolution is Wedge Product

  #snote[Scalar: multiplication in space $<->$ convolution in frequency. Same holds for forms.]

  #v(0.3cm)

  #defbox(title: "Convolution of differential forms")[
    For $alpha in Omega(r)(RR^n)$, $beta in Omega(l)(RR^n)$, define the $(r+l-n)$-form:
    $
      (alpha * beta)(dif y)
        = integral_(RR^n) alpha(dif x) wedge beta(dif y - dif x)
    $
  ]

  #v(0.3cm)

  #propbox(title: "Convolution is Wedge in Frequency")[
    $
      cal(F)(alpha * beta) = hat(alpha) wedge hat(beta)
        in hat(Omega)(n-r-l)(hat(RR)^n)
    $
  ]
]

#slide[
  = Spectral Calculus

  Calculus becomes Algebra in the Fourier domain.

  Differential Operators become purely algebraic operators, meaning
  differentiation becomes mutliplication.
]

#slide[
  = FT of the Exterior Derivative is Contraction

  #snote[Under $cal(F)$, the exterior derivative $dif$ becomes a contraction]

  #v(0.3cm)

  #defbox(title: "Proposition 4")[
    The Fourier transform of $dif : Omega(r) -> Omega(r+1)$ is the *interior product*
    with the position vector $xi = xi_1 dif xi_1 + dots + xi_n dif xi_n$:
    $
      cal(F)(dif alpha)(xi)
        = hat(dif) hat(alpha)(xi)
        = ii_(i xi) hat(alpha)(xi)
    $
    where $ii_(i xi)$ denotes the interior product (contraction) with $ii xi$.
  ]

  #v(0.4cm)

  #align(center)[
    #diagram(
      node-stroke: 0pt,
      spacing: (4cm, 1.8cm),
      node((0,0), $Omega(r)(RR^n)$),
      node((1,0), $Omega(r+1)(RR^n)$),
      node((0,1), $hat(Omega)(n-r)(hat(RR)^n)$),
      node((1,1), $hat(Omega)(n-r-1)(hat(RR)^n)$),
      edge((0,0), (1,0), $dif$, "->", label-side: auto),
      edge((0,0), (0,1), $cal(F)$, "->", label-side: right),
      edge((1,0), (1,1), $cal(F)$, "->", label-side: left),
      edge((0,1), (1,1), $hat(dif) = ii_(i xi)$, "->", label-side: auto),
    )
  ]
]

#slide[
  = The spherical nature of Spectral Exterior Calculus

  Not only is the differentiation purely algebraic in fourier space, it's
  even more specific. It is a purely radial operation.
  When looking at fourier space through spherical coordinates,
  differentiation becomes multiplication by the radial frequency vector.

  $
    xi = abs(xi) hat(xi)
  $

  Exact forms (in the image of $dif$): Purely angular.
  Coexact forms (in the image of $delta$: Purely radial.

  The exterior derivative and the codifferential are radial operators
  $
    hat(dif) = ii_(i xi) \
    hat(delta) = (i xi) wedge dot
  $


    Spherical coordinates in $hat(RR)^n$ are *natural* for the Fourier de Rham complex:
    $xi = |xi| hat(r)$, so $ii_(i xi)$ acts only radially —
    exact and co-exact forms decouple by direction alone.
    This is the foundation of $Psi$ec.
  
]

#slide[
  = Spectral Vector Calculus

  $
    grad f = nabla f = i xi hat(f)(xi) \
    curl f = nabla times u = i xi times hat(u)(k) \
    div f = nabla dot u = i xi dot hat(u)(k) \
  $

  Stems from the fact that the Fourier modes are plane waves $e^(i xi x)$
  with derivative
  $
    grad e^(i xi x) = i xi e^(i xi x)
  $
]

#slide[
  = Differentiation is so simple
  #snote[Only a question of adding and removing of radial components]

  $hat(d)$ removes $hat(r)^flat$
  $hat(delta)$ adds $hat(r)^flat$

  And therefore $hat(d)^2 = 0$ and $hat(delta)^2 = 0$,
  because it's a binary statement. Does the form contain a radial component or not. 1 or 0.
  You cannot have multiple radial components because of the antisymmetry.
]


#slide[
  = The Fourier-de Rham Chain Complex

  #snote[The co-chain complex in space maps to a chain complex in frequency]

  #v(0.4cm)

  Since $ii_(i xi) iota_(i xi) = 0$, the frequency-domain forms form a *chain complex*:

  #v(0.2cm)

  #defbox[
    #align(center)[
      $
        0 arrow.l hat(Omega)(0)
          arrow.l^(ii_(i xi)) hat(Omega)(1)
          arrow.l^(ii_(i xi)) dots.c
          arrow.l^(ii_(i xi)) hat(Omega)(n)
          arrow.l 0
      $
    ]
  ]

  #v(0.5cm)

  The full picture — both rows commute under $hat$:

  #v(0.2cm)

  #align(center)[
    #diagram(
      node-stroke: 0pt,
      spacing: (3.2cm, 1.6cm),
      node((0,0), $dots$),
      node((1,0), $Omega(r)(RR^n)$),
      node((2,0), $Omega(r+1)(RR^n)$),
      node((3,0), $dots$),
      node((0,1), $dots$),
      node((1,1), $hat(Omega)(n-r)(hat(RR)^n)$),
      node((2,1), $hat(Omega)(n-r-1)(hat(RR)^n)$),
      node((3,1), $dots$),
      edge((0,0), (1,0), "->"),
      edge((1,0), (2,0), $dif$, "->", label-side: auto),
      edge((2,0), (3,0), "->"),
      edge((0,1), (1,1), "<-"),
      edge((1,1), (2,1), $ii_(i xi)$, "<-", label-side: auto),
      edge((2,1), (3,1), "<-"),
      edge((1,0), (1,1), $cal(F)$, "->", label-side: right),
      edge((2,0), (2,1), $cal(F)$, "->", label-side: left),
    )
  ]

  #v(0.3cm)
  #snote[Key: in spherical coordinates, $xi = |xi| hat(r)$, so $ii_(i xi)$ acts only on the *radial direction* — exact/co-exact parts decouple cleanly.]
]


#slide[
  = Computation!
  #snote[Spectral Basis Functions Needed!]

  How to construct them?

  Here comes the beauty! We don't construct discrete counterparts but instead use
  just special differential forms.

  Our discrete objects are not special, they are the same kind of objects are the continous one.
  This is not the case in DEC and FEEC.
  Structure-preservation is FOR FREE!!!
]

#slide[
  = Choice of Basis Functions
  #snote[Heisenberg Uncertainty]

  Dirac Delta is perfectly localized in space, but has zero localization in frequency (one everywhere).
  $
    delta(x-x_0) quad <--> quad e^(i x_0 xi)
  $
  Basically Finite Difference / Finite Elements in spirit. No periodicity, no continuity.

  The plane wave is perfectly localized in frequency, but has zero localization in space (spreads everywhere).
  $
    e^(i xi_0 x) quad <--> quad delta(xi - xi_0)
  $
  Works well for periodic problems with no locality/singularity. Purely spectral method.

  These are Fourier duals of each other.
  
  In general functions need to obey the *Heisenberg uncertainty principle*.
  $
    Delta x Delta xi >= 1/2
  $


  The Gaussian minimizes this uncertainty product $Delta x Delta xi =^! 1/2$
  $
    g(x) = exp(-x^2/(2sigma^2))
  $
  It's Fourier transform is also a Gaussian
  $
    hat(g)(xi) = exp(-(sigma^2 xi^2)/2)
  $
]

#slide[
  = Wavelets
  #snote[Provide localization in space and frequency!]

  Trade off, between localization in space and frequency.

  Wavelets strike a balance.

  Wavelets are the natural basis functions for a theory that lives in the Fourier
  domain but needs to be computed locally in space.

  The 2D space $times$ frequency space. A function always occupies a tile of area >= 1/2.

  Can have different shapes.

  This paper develops differential-form wavelets with spherical coordinates in frequency space.

  *Polar wavelet*
  They use a factored window $hat(psi)(rho, theta) = h(rho) h(theta)$
  where $h$ handles scale (where $dif$ and $delta$ act) and $g$ handles direction

  There are wavelets for exact and co-exact forms.
  $
    hat(psi)^(r,dif)_s = hat(psi)(rho, theta) omega^r_perp (theta)
    \
    hat(psi)^(r,delta)_s = hat(psi)(rho, theta) hat(r)^flat wedge omega^r_perp (theta)
  $

  Full wavelet notation:
  $
    psi^(r, nu, n)_(s,a)
  $
  - form degree $r in {0,...,n}$
  - exact / coexact $nu in {dif, delta}$
  - geometry $s = (j,k,t)$; scale $j$, translation $k$, orientation $t$
  - angular parameter $a$

  Exterior derivative maps wavelets to wavelets
  $
    dif psi^(r,delta)_s = psi^(r+1,dif)_s
  $

  $
    dif psi_s^(r,d)​= 0
  $
  
]

