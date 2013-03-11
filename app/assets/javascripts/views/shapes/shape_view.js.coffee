Hospiglu.module "Views.Shapes", ->
  class @ShapeView extends Marionette.ItemView
    render: ->
      @options.scale ||= 1
      unless @options.noEditing and @model.get('in_menu')
        paper = @options.paper
        shape = @createShape(@model, paper)
        shape.model = @model
        shape.view = @
        shape.collection = @model.collection
        @model.el = shape
        shape.mousedown @cloneShape if @model.get('in_menu')
      @

    cloneShape: (event) ->
      Hospiglu.selectedMenuItem?.remove()
      delete Hospiglu.selectedMenuItem
      newModel = @model.clone()
      newModel.set('properties', _.clone(@model.get('properties')))
      newModel.unset('id')
      newModel.set('in_menu', false)
      shape = @view.createShape(newModel, @paper)
      shape.view = @view
      shape.model = newModel
      newModel.el = shape
      shape.collection = @model.collection
      _.select(shape.events, (event) ->
        event.f.name == 'start'
      )[0].f.call shape, event

    createShape: (model, paper) ->
      in_menu = model.get('in_menu')
      shapeProperties = model.get('properties')
      y = if not model.collection or in_menu
        shapeProperties.y * @options.scale
      else
        shapeProperties.y * @options.scale + 100 # move below menu
      shape = paper[shapeProperties.shape_type].call(
        paper,
        shapeProperties.x * @options.scale,
        y, # move below menu
        shapeProperties.width * @options.scale,
        shapeProperties.height * @options.scale,
        shapeProperties.border_radius * @options.scale
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
        cursor: 'move' unless @options.noEditing
      if in_menu
        shape.mouseover -> @glowSet = @glow(color: '#0088cc', opacity: 1)
        shape.mouseout -> @glowSet?.remove()
      else if not @options.noEditing
        shape.mousedown(@initDummy)
        shape.drag(@move, @down, @up)
        shape.mouseup(@handleDelete)
      shape

    onClose: ->
      @shape?.remove()

    handleDelete: ->
      if Hospiglu.selectedMenuItem?.trash and Hospiglu.getSemaphore()
        Hospiglu.connectionsCallbacks.add =>
          _.each @model.outgoingConnections(), (connection) ->
            connection.destroy()
          _.each @model.incomingConnections(), (connection) ->
            connection.destroy()
          @model.destroy()
          @model.el.remove()
        Hospiglu.selectedMenuItem.remove()
        delete Hospiglu.selectedMenuItem

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
      if Hospiglu.getSemaphore()
        model = @model
        collection = @collection
        box = @getBBox()
        [x, y, ox, oy] = [@x, @y, @ox, @oy]
        @remove() unless model.collection?
        if x? and y? and (x isnt ox or y isnt oy)
          shapeProperties = model.get('properties')
          # is the new shape position below the menu?
          if box.y >= 100
            shapeProperties.x = x
            shapeProperties.y = y - 100 # subtract menu
            model.set properties: shapeProperties
            collection.add model
            model.save()
        @animate
            "fill-opacity": 0
          , 500

    initDummy: (event) ->
      return unless Hospiglu.selectedMenuItem?
      return if Hospiglu.selectedMenuItem?.trash
      return unless @model?.id
      x = event.offsetX || (event.clientX - @paper.canvas.offsetLeft)
      y = event.offsetY || (event.clientY - @paper.canvas.offsetTop)
      dummy = @paper.ellipse(x, y, 5, 5).attr(opacity: 0, fill: '#fff', cursor: 'move')
      dummy.startShape = @model.el
      dummy.drag(@view.moveConnection, @view.initConnection, @view.saveConnection)
      dummy.onDragOver @view.snapConnectionTo
      _.select(dummy.events, (event) ->
        event.f.name == 'start'
      )[0].f.call dummy, event

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


