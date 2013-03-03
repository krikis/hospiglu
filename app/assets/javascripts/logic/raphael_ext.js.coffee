Raphael.fn.curvedPath = (options) ->
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
    'stroke-width': options.strokeWidth
    'stroke-opacity': options.strokeOpacity
    cursor: options.pointer
  path