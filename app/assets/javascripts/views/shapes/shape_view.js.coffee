Hospiglu.module "Views.Shapes", ->
  class @ShapeView extends Marionette.ItemView
    render: ->
      paper = @options.paper
      shape = @createShape(@model, paper)
      shape.model = @model
      shape.view = @
      shape.collection = @model.collection
      @model.el = shape
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
        shape.mousedown(@initDummy)
        shape.drag(@move, @down, @up)
      shape

    onClose: ->
      @shape?.remove()

    cloneShape: (event) ->
      newModel = @model.clone()
      newModel.set('properties', _.clone(@model.get('properties')))
      newModel.unset('id')
      newModel.set('in_menu', false)
      shape = @view.createShape(newModel, @paper)
      shape.view = @view
      shape.model = newModel
      shape.collection = @model.collection
      console.log shape.events
      _.each _.select(shape.events, (e) ->
        e.name == event.type
      ), (e) -> e.f.call shape, event

    move: (dx, dy) ->
      return if Hospiglu.selectedMenuItem?
      @x = @ox + dx
      @y = @oy + dy
      if @type is "rect"
        @y = if @model.collection? and @y < 100 then 100 else @y
        @attr
          x: @x
          y: @y
      else
        @y = if @model.collection? and @y - @attr('ry') < 100
          100 + @attr('ry')
        else
          @y
        @attr
          cx: @x
          cy: @y
      Hospiglu.connectionsCallbacks.add =>
        _.each @model.outgoingConnections(), (connection) =>
          @paper.connection connection.el
        _.each @model.incomingConnections(), (connection) =>
          @paper.connection connection.el
      @paper.safari()

    down: ->
      return if Hospiglu.selectedMenuItem?
      @ox = (if @type is "rect" then @attr("x") else @attr("cx"))
      @oy = (if @type is "rect" then @attr("y") else @attr("cy"))
      @animate
        "fill-opacity": .2
      , 500

    up: ->
      return if Hospiglu.selectedMenuItem?
      if @x? and @y? and (@x isnt @ox or @y isnt @oy)
        model = @model
        shapeProperties = model.get('properties')
        # is the new shape position below the menu?
        if @getBBox().y >= 100
          shapeProperties.x = @x
          shapeProperties.y = @y
          model.set properties: shapeProperties
          unless model.collection?
            @collection.add model
            @remove()
          model.save()
        else if not model.collection?
          @remove()

      @animate
          "fill-opacity": 0
        , 500

    initDummy: (event) ->
      return unless Hospiglu.selectedMenuItem?
      x = event.offsetX || (event.clientX - @paper.canvas.offsetLeft)
      y = event.offsetY || (event.clientY - @paper.canvas.offsetTop)
      dummy = @paper.ellipse(x, y, 5, 5).attr(opacity: 0, fill: '#fff', cursor: 'move')
      dummy.startShape = @model.el
      dummy.drag(@view.moveConnection, @view.initConnection, @view.saveConnection)
      dummy.onDragOver @view.snapConnectionTo
      _.each _.select(dummy.events, (e) ->
        e.name == event.type
      ), (e) -> e.f.call dummy, event

    initConnection: ->
      @ox = @attr("cx")
      @oy = @attr("cy")
      @menuItem = Hospiglu.selectedMenuItem
      @connection = @menuItem.view.createConnection(@menuItem.model, @startShape, @, @paper)
      @toFront()

    moveConnection: (dx, dy) ->
      @y = @oy + dy
      @attr
        cx: @ox + dx
        cy: if @y >= 110 then @y else 110
      @paper.connection(@connection)
      @paper.safari()

    saveConnection: ->
      clearTimeout @releaseConnection
      unless @connection.to == @
        newModel = @menuItem.model.clone()
        newModel.set('properties', _.clone(@menuItem.model.get('properties')))
        newModel.unset('id')
        newModel.set('in_menu', false)
        newModel.set('start_shape_id', @connection.from.model.get('id'))
        newModel.set('end_shape_id', @connection.to.model.get('id'))
        @menuItem.model.collection.create newModel
      @connection.line.remove()
      @connection.bg?.remove()
      delete @connection
      @.remove()
      Hospiglu.selectedMenuItem?.remove()
      delete Hospiglu.selectedMenuItem

    snapConnectionTo: (shape) ->
      if @connection? and shape isnt @connection.from and
         shape.type isnt 'path' and not shape.model?.get('in_menu')
        clearTimeout @releaseConnection
        @connection.to = shape
        @paper.connection(@connection)
        @paper.safari()
        {x: ox, y: oy} = @getBBox()
        @releaseCallbacks = new Marionette.Callbacks()
        @releaseConnection = setTimeout (=>
            @releaseCallbacks.run {}, @
          ), 100
        @releaseCallbacks.add =>
          {x: x, y: y} = @getBBox()
          # did the dummy move out?
          if Math.sqrt(Math.pow(Math.abs(x - ox), 2) + Math.pow(Math.abs(y - oy), 2)) > 10
            @connection.to = @
            @paper.connection(@connection)
            @paper.safari()
