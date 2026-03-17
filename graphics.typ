#let fgcolor = white

#let wavelet-plot(
  func,
  width: 200pt,
  height: 120pt,
  xmin: -4.0,
  xmax: 4.0,
  ymin: -1.0,
  ymax: 1.0,
  col: blue.lighten(20%),
  n: 300,
) = {
  let w = width
  let h = height
  let to-px(x, y) = {
    let px = (x - xmin) / (xmax - xmin) * w
    let py = (1.0 - (y - ymin) / (ymax - ymin)) * h
    (px, py)
  }

  box(width: w, height: h, {
    // x-axis
    let (ax0, ay) = to-px(xmin, 0)
    let (ax1, _) = to-px(xmax, 0)
    place(line(start: (ax0, ay), end: (ax1, ay), stroke: 0.7pt + fgcolor.transparentize(60%)))

    // y-axis
    let (cx, cy0) = to-px(0, ymin)
    let (_, cy1) = to-px(0, ymax)
    place(line(start: (cx, cy0), end: (cx, cy1), stroke: 0.7pt + fgcolor.transparentize(60%)))

    // curve
    for i in range(n) {
      let x1 = xmin + (xmax - xmin) * i / n
      let x2 = xmin + (xmax - xmin) * (i + 1) / n
      let y1 = func(x1)
      let y2 = func(x2)
      // clamp
      let y1c = calc.min(calc.max(y1, ymin), ymax)
      let y2c = calc.min(calc.max(y2, ymin), ymax)
      let (px1, py1) = to-px(x1, y1c)
      let (px2, py2) = to-px(x2, y2c)
      place(line(start: (px1, py1), end: (px2, py2), stroke: 1.8pt + col))
    }
  })
}

#let haar(x) = {
  if x >= 0.0 and x < 0.5 { 1.0 }
  else if x >= 0.5 and x < 1.0 { -1.0 }
  else { 0.0 }
}
#let mexican-hat(x) = {
  (1.0 - x * x) * calc.exp(-x * x / 2.0)
}
#let morlet(x) = {
  calc.exp(-x * x / 2.0) * calc.cos(5.0 * x)
}
#let gaussian(x) = {
  calc.exp(-x * x / 2.0)
}


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

