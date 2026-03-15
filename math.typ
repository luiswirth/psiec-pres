#let math-template(doc) = {
  show math.equation: set text(font: "New Computer Modern Math")
  set math.mat(delim: "[")
  set math.vec(delim: "[")
  doc
}

// Differential
#let dif = math.class("unary", math.upright($d$))

// Complex numbers
#let ii = $dotless.i$

// Vectors and matrices
#let avec(a) = math.bold(a)
#let vvec(a) = math.accent(math.bold(a), math.arrow)
#let nvec(a) = math.accent(avec(a), math.hat)
#let amat(a) = math.upright(math.bold(a))
#let tens(a) = math.sans(math.bold(a))

// Transpose and adjoint
#let tp = math.top
#let herm = math.upright(math.sans("H"))

// Vector calculus
#let grad = math.op(avec("grad"))
#let curl = math.op(avec("curl"))
#let scurl = math.op("curl")
#let div = math.op("div")
#let lapl = math.Delta
#let tr = math.op("tr")
#let diag = math.op("diag")
#let sgn = math.op("sgn")

// Optimization
#let argmin = math.op("arg min", limits: true)
#let argmax = math.op("arg max", limits: true)

// Differential forms
#let wedge = math.and
#let wedgespace = math.scripts(math.inline(wedge.big))
#let hodge = math.class("unary", math.star)
#let sharp = math.class("unary", [♯])
#let flat = math.class("unary", [♭])

// Intervals (Bourbaki)
#let oo(a, b) = $lr(\] #a, #b \[)$
#let cc(a, b) = $lr(\[ #a, #b \])$
#let oc(a, b) = $lr(\] #a, #b \])$
#let co(a, b) = $lr(\[ #a, #b \[)$

// Closure
#let clos(a) = math.overline(a)

// Inner product
#let angled(a) = math.lr($chevron.l #a chevron.r$)
#let ip(a, b) = angled($#a, #b$)

// Tensor product
#let tprod = math.times.o
