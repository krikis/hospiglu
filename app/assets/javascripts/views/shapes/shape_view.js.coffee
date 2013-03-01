Hospiglu.module "Views.Shapes", ->
  class @ShapeView extends Marionette.ItemView
    dragger: ->
      @ox = (if @type is "rect" then @attr("x") else @attr("cx"))
      @oy = (if @type is "rect" then @attr("y") else @attr("cy"))
      @animate
        "fill-opacity": .2
      , 500

    move: (dx, dy) ->
      att = (if @type is "rect"
        x: @ox + dx
        y: @oy + dy
       else
        cx: @ox + dx
        cy: @oy + dy
      )
      @attr att
      _.each @model.outgoingConnections(), (connection) =>
        @paper.connection connection.el
      _.each @model.incomingConnections(), (connection) =>
        @paper.connection connection.el
      @paper.safari()

    up: ->
      @animate
          "fill-opacity": 0
        , 500

    render: ->
      raphael = @options.raphael
      shapeProperties = @model.get('properties')
      @shape = raphael[shapeProperties.shape_type].call(
        raphael,
        shapeProperties.x,
        shapeProperties.y,
        shapeProperties.width,
        shapeProperties.height,
        shapeProperties.border_radius
      )
      @shape.model = @model
      @model.el = @shape
      color = Raphael.getColor()
      @shape.attr
        fill: color
        stroke: color
        'fill-opacity': 0
        'stroke-width': 2
        cursor: 'move'
      @shape.drag(@move, @dragger, @up)
      @

    onClose: ->
      @shape?.remove()
