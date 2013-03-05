Raphael.fn.curvedpath = (options) ->
  path = @path("M,#{options.x.toFixed(3)},\
                  #{options.y.toFixed(3)},\
                C,#{options.cx.toFixed(3)},\
                  #{options.cy.toFixed(3)},\
                  #{options.cx2.toFixed(3)},\
                  #{options.cy2.toFixed(3)},\
                  #{options.x2.toFixed(3)},\
                  #{options.y2.toFixed(3)}")
  path.attr
    stroke: options.stroke
    'stroke-width': options['stroke-width']
    'stroke-opacity': options['stroke-opacity']
    fill: options.fill
    'fill-opacity': options['fill-opacity']
    cursor: options.cursor
  path

Raphael.fn.rectangle = (options) ->
  shape = @rect(options.x, options.y, options.width, options.height)
  shape.attr
    stroke: options.stroke
    'stroke-width': options['stroke-width']
    'stroke-opacity': options['stroke-opacity']
    fill: options.fill
    'fill-opacity': options['fill-opacity']
    cursor: options.cursor
  shape

Raphael.fn.trashcan = (options) ->
  path = @path("""
               M20.826,5.75\
               l0.396,1.188\
               c1.54,0.575,2.589,1.44,2.589,2.626\
               c0,2.405-4.308,3.498-8.312,3.498\
               c-4.003,0-8.311-1.093-8.311-3.498\
               c0-1.272,1.21-2.174,2.938-2.746\
               l0.388-1.165\
               c-2.443,0.648-4.327,1.876-4.327,3.91v2.264\
               c0,1.224,0.685,2.155,1.759,2.845l0.396,9.265\
               c0,1.381,3.274,2.5,7.312,2.5\
               c4.038,0,7.313-1.119,7.313-2.5\
               l0.405-9.493\
               c0.885-0.664,1.438-1.521,1.438-2.617\
               V9.562\
               C24.812,7.625,23.101,6.42,20.826,5.75z\
               M11.093,24.127\
               c-0.476-0.286-1.022-0.846-1.166-1.237\
               c-1.007-2.76-0.73-4.921-0.529-7.509\
               c0.747,0.28,1.58,0.491,2.45,0.642\
               c-0.216,2.658-0.43,4.923,0.003,7.828\
               C11.916,24.278,11.567,24.411,11.093,24.127z\
               M17.219,24.329\
               c-0.019,0.445-0.691,0.856-1.517,0.856\
               c-0.828,0-1.498-0.413-1.517-0.858\
               c-0.126-2.996-0.032-5.322,0.068-8.039\
               c0.418,0.022,0.835,0.037,1.246,0.037\
               c0.543,0,1.097-0.02,1.651-0.059\
               C17.251,18.994,17.346,21.325,17.219,24.329z\
               M21.476,22.892\
               c-0.143,0.392-0.69,0.95-1.165,1.235\
               c-0.474,0.284-0.817,0.151-0.754-0.276\
               c0.437-2.93,0.214-5.209-0.005-7.897\
               c0.881-0.174,1.708-0.417,2.44-0.731\
               C22.194,17.883,22.503,20.076,21.476,22.892z\
               M11.338,9.512\
               c0.525,0.173,1.092-0.109,1.268-0.633\
               h-0.002l0.771-2.316\
               h4.56l0.771,2.316\
               c0.14,0.419,0.53,0.685,0.949,0.685\
               c0.104,0,0.211-0.017,0.316-0.052\
               c0.524-0.175,0.808-0.742,0.633-1.265\
               l-1.002-3.001\
               c-0.136-0.407-0.518-0.683-0.945-0.683h-6.002\
               c-0.428,0-0.812,0.275-0.948,0.683l-1,2.999\
               C10.532,8.77,10.815,9.337,11.338,9.512z
               """)
  path.transform("t#{options.x},
                   #{options.y}\
                  s#{options.size}")
  path.attr(stroke: options.stroke)
  path

Raphael.fn.connection = (obj1, obj2, line, bg, strokeWidth, backgroundStrokeWidth) ->
  if obj1.line and obj1.from and obj1.to
    line = obj1
    obj1 = line.from
    obj2 = line.to
  bb1 = obj1.getBBox()
  bb2 = obj2.getBBox()
  p = [
    x: bb1.x + bb1.width / 2
    y: bb1.y - 1
  ,
    x: bb1.x + bb1.width + 1
    y: bb1.y + bb1.height / 2
  ,
    x: bb1.x + bb1.width / 2
    y: bb1.y + bb1.height + 1
  ,
    x: bb1.x - 1
    y: bb1.y + bb1.height / 2
  ,
    x: bb2.x + bb2.width / 2
    y: bb2.y - 1
  ,
    x: bb2.x + bb2.width + 1
    y: bb2.y + bb2.height / 2
  ,
    x: bb2.x + bb2.width / 2
    y: bb2.y + bb2.height + 1
  ,
    x: bb2.x - 1
    y: bb2.y + bb2.height / 2
  ]
  d = {}
  dis = []
  for i in [0...4]
    j = ((i + 2) % 4) + 4
    dx = Math.abs(p[i].x - p[j].x)
    dy = Math.abs(p[i].y - p[j].y)
    if (i is j - 4) or
       (((i isnt 1 and j isnt 7) or p[i].x < p[j].x) and
        ((i isnt 3 and j isnt 5) or p[i].x > p[j].x) and
        ((i isnt 0 and j isnt 6) or p[i].y > p[j].y) and
        ((i isnt 2 and j isnt 4) or p[i].y < p[j].y))
      dis.push Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2))
      d[dis[dis.length - 1]] = [i, j]
  if dis.length is 0
    res = [0, 4]
  else
    res = d[Math.min.apply(Math, dis)]
  x1 = p[res[0]].x
  y1 = p[res[0]].y
  x4 = p[res[1]].x
  y4 = p[res[1]].y
  dx = Math.max(Math.abs(x1 - x4) / 2, 10)
  dy = Math.max(Math.abs(y1 - y4) / 2, 10)
  x2 = [x1, x1 + dx, x1, x1 - dx][res[0]].toFixed(3)
  y2 = [y1 - dy, y1, y1 + dy, y1][res[0]].toFixed(3)
  x3 = [0, 0, 0, 0, x4, x4 + dx, x4, x4 - dx][res[1]].toFixed(3)
  y3 = [0, 0, 0, 0, y1 + dy, y4, y1 - dy, y4][res[1]].toFixed(3)
  path = ["M", x1.toFixed(3), y1.toFixed(3), "C", x2, y2, x3, y3, x4.toFixed(3), y4.toFixed(3)].join(",")
  if line and line.line
    line.bg and line.bg.attr(path: path)
    line.line.attr path: path
    line.target.attr path: path
  else
    color = (if typeof line is "string" then line else "#000")
    bg: bg and @path(path).attr(
      stroke: bg
      fill: "none"
      "stroke-width": backgroundStrokeWidth or 3
    )
    line: @path(path).attr(
      stroke: color
      'stroke-width': strokeWidth
      fill: "none"
    )
    target: @path(path).attr(
      stroke: color
      'stroke-width': 20
      opacity: 0
      fill: "none"
    )
    from: obj1
    to: obj2
