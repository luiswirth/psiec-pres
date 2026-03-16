#let flow-svg(
  curves,
  width: 200,
  height: 200,
  xmin: -2.0, xmax: 2.0,
  ymin: -2.0, ymax: 2.0,
  col: "hsl(210,80%,60%)",
  stroke-width: 2.0,
) = {
  let to-svg(x, y) = {
    let sx = calc.round((x - xmin) / (xmax - xmin) * width, digits: 2)
    let sy = calc.round((1.0 - (y - ymin) / (ymax - ymin)) * height, digits: 2)
    (sx, sy)
  }

  let paths = ""
  for curve in curves {
    let d = ""
    for (i, pt) in curve.enumerate() {
      let (x, y) = pt
      let (sx, sy) = to-svg(x, y)
      let cmd = if i == 0 { "M" } else { "L" }
      d += cmd + str(sx) + " " + str(sy)
    }
    if d != "" {
      paths += "<path d='" + d + "' fill='none' "
      paths += "stroke='" + col + "' "
      paths += "stroke-width='" + str(stroke-width) + "' "
      paths += "stroke-linecap='round' "
      paths += "stroke-linejoin='round'/>\n"
    }
  }

  let svg = "<svg xmlns='http://www.w3.org/2000/svg' "
  svg += "viewBox='0 0 " + str(width) + " " + str(height) + "'>"
  svg += paths
  svg += "</svg>"
  image(bytes(svg), width: width * 1pt, height: height * 1pt)
}

#let source-curves = {
  let ncurves = 24
  let xmin = -2.0
  let xmax = 2.0
  let ymin = -2.0
  let ymax = 2.0
  range(ncurves).map(i => {
    let theta = 2.0 * calc.pi * i / ncurves
    let cx = calc.cos(theta)
    let cy = calc.sin(theta)
    let t = 10.0
    if cx > 0 { t = calc.min(t, xmax / cx) }
    if cx < 0 { t = calc.min(t, xmin / cx) }
    if cy > 0 { t = calc.min(t, ymax / cy) }
    if cy < 0 { t = calc.min(t, ymin / cy) }
    ((0.0, 0.0), (t * cx, t * cy))
  })
}

#let vortex-curves = {
  let n = 8
  range(n).map(i => {
    let r = 0.25 * (i + 1)
    let npoints = 121
    range(npoints).map(j => {
      let t = 2.0 * calc.pi * j / (npoints - 1)
      (r * calc.cos(t), r * calc.sin(t))
    })
  })
}

#let spiral-curves = {
  let r0 = 0.05
  let ncurves = 24
  range(ncurves).map(i => {
    let theta0 = 2.0 * calc.pi * i / ncurves
    let npoints = 301
    range(npoints).map(j => {
      let t = 4.0 * j / (npoints - 1)
      let r = r0 * calc.exp(t)
      (r * calc.cos(t + theta0), r * calc.sin(t + theta0))
    })
  })
}

