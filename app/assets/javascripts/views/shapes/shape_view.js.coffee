Hospiglu.module "Views.Shapes", ->
  class @ShapeView extends Marionette.ItemView
    cloneShape: (event) ->
      newModel = @model.clone()
      newModel.set('properties', _.clone(@model.get('properties')))
      newModel.unset('id')
      newModel.set('in_menu', false)
      newModel.event = event
      @model.collection.add newModel

    move: (dx, dy) ->
      @x = @ox + dx
      @y = @oy + dy
      att = (if @type is "rect"
        x: @x
        y: @y
       else
        cx: @x
        cy: @y
      )
      @attr att
      Hospiglu.connectionsCallbacks.add =>
        _.each @model.outgoingConnections(), (connection) =>
          @paper.connection connection.el
        _.each @model.incomingConnections(), (connection) =>
          @paper.connection connection.el
      @paper.safari()

    dragger: ->
      @ox = (if @type is "rect" then @attr("x") else @attr("cx"))
      @oy = (if @type is "rect" then @attr("y") else @attr("cy"))
      @animate
        "fill-opacity": .2
      , 500

    up: ->
      if @x? and @y? and (@x isnt @ox or @y isnt @oy)
        shapeProperties = @model.get('properties')
        shapeProperties.x = @x
        shapeProperties.y = @y
        @model.set properties: shapeProperties
        @model.save()
      @animate
          "fill-opacity": 0
        , 500

    render: ->
      paper = @options.paper
      shape = @createShape(@model, paper)
      shape.events[0].f.call shape, @model.event if @model.event
      shape.mousedown @cloneShape if @model.get('in_menu')
      @model.el = shape
      @

    createShape: (model, paper) ->
      in_menu = model.get('in_menu')
      shapeProperties = model.get('properties')
      shape = paper[shapeProperties.shape_type].call(
        paper,
        shapeProperties.x,
        shapeProperties.y,
        shapeProperties.width,
        shapeProperties.height,
        shapeProperties.border_radius
      )
      shape.model = model
      color = if in_menu
        '#fff'
      else
        shapeProperties.color || Raphael.getColor()
      shape.attr
        fill: color
        stroke: color
        'fill-opacity': 0
        'stroke-width': 2
        cursor: 'move'
      if in_menu
        shape.mouseover -> @glowSet = @glow(color: '#0088cc', opacity: 1)
        shape.mouseout -> @glowSet?.remove()
      else
        shape.drag(@move, @dragger, @up)
      shape

    onClose: ->
      @shape?.remove()
