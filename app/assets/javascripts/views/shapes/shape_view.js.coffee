Hospiglu.module "Views.Shapes", ->
  class @ShapeView extends Marionette.ItemView
    render: ->
      paper = @options.paper
      shape = @createShape(@model, paper)
      shape.model = @model
      shape.view = @
      @model.el = shape
      if @model.event
        _.select(
          shape.events, (event) ->
            event.name == 'mousedown'
        )[0].f.call shape, @model.event
      shape.mousedown @cloneShape if @model.get('in_menu')
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
        shape.drag(@moveDelegator, @downDelegator, @upDelegator)
        shape.onDragOver @snapConnectionTo
      shape

    onClose: ->
      @shape?.remove()

    cloneShape: (event) ->
      newModel = @model.clone()
      newModel.set('properties', _.clone(@model.get('properties')))
      newModel.unset('id')
      newModel.set('in_menu', false)
      newModel.event = event
      @model.collection.add newModel

    moveDelegator: ->
      if Hospiglu.selectedMenuItem?
        @view.moveConnection.apply(@, arguments)
      else
        @view.move.apply(@, arguments)

    downDelegator: ->
      if Hospiglu.selectedMenuItem?
        @view.initConnection.apply(@, arguments)
      else
        @view.down.apply(@, arguments)

    upDelegator: ->
      if Hospiglu.selectedMenuItem?
        @view.saveConnection.apply(@, arguments)
      else
        @view.up.apply(@, arguments)

    moveConnection: (dx, dy) ->
      @dummy.attr x: @ox + dx, y: @oy + dy
      @paper.connection(@connection)
      @paper.safari()

    initConnection: (x, y, event) ->
      @ox = event.offsetX
      @oy = event.offsetY
      @dummy = @paper.rect(@ox, @oy, 10, 10)#.attr(opacity: 0)
      @menuItem = Hospiglu.selectedMenuItem
      @connection = @menuItem.view.createConnection(@menuItem.model, @model.el, @dummy, @paper)

    snapConnectionTo: (shape) ->
      if @connection? and @dummy? and shape isnt @connection.from and shape isnt @dummy and shape.type isnt 'path'
        clearTimeout @releaseConnection
        @connection.to = shape
        @paper.connection(@connection)
        @paper.safari()
        {x: ox, y: oy} = @dummy.getBBox()
        @releaseConnection = setTimeout (=>
            {x: x, y: y} = @dummy.getBBox()
            # did the dummy move out?
            if Math.sqrt(Math.pow(Math.abs(x - ox), 2) + Math.pow(Math.abs(y - oy), 2)) > 10
              @connection.to = @dummy
              @paper.connection(@connection)
              @paper.safari()
          ), 200

    saveConnection: ->
      clearTimeout @releaseConnection
      if @connection.to == @dummy
        @connection.line.remove()
        @connection.bg?.remove()
      delete @connection
      @dummy.remove()
      Hospiglu.selectedMenuItem?.remove()
      delete Hospiglu.selectedMenuItem

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

    down: ->
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
