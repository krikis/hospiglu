Hospiglu.module "Views.Shapes", ->
  class @ShapeView extends Marionette.ItemView
    render: ->
      @options.scale ||= 1
      unless @options.noEditing and @model.get('in_menu')
        paper = @options.paper
        @shape = @createShape(@model, paper)
        @shape.model = @model
        @shape.view = @
        @shape.collection = @model.collection
        @model.el = @shape
        @shape.mousedown @cloneShape if @model.get('in_menu')
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
      inMenu = model.get('in_menu')
      shapeProperties = model.get('properties')
      y = if not model.collection or inMenu or @options.noEditing
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
      color = if inMenu
        '#fff'
      else
        shapeProperties.color || Raphael.getColor()
      shape.attr
        fill: color
        stroke: color
        'fill-opacity': 0
        'stroke-width': 2
        cursor: 'move' unless @options.noEditing
      if inMenu
        shape.mouseover -> @glowSet = @glow(color: '#0088cc', opacity: 1)
        shape.mouseout -> @glowSet?.remove()
      else if not @options.noEditing
        shape.mousedown(@initDummy)
        shape.drag(@move, @down, @up)
        shape.mouseup(@handleDelete)
        shape.dblclick(@editText)
        shape.mousedown(@initEditGesture)
        shape.mouseup(@detectEditGesture)
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
        Hospiglu.selectedMenuItem.remove()
        delete Hospiglu.selectedMenuItem

    move: (dx, dy) ->
      return if Hospiglu.selectedMenuItem?
      @dx = Math.max Math.abs(dx), @dx || 0
      @dy = Math.max Math.abs(dy), @dy || 0
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
      @dx = @dy = 0
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
      if @connection.to isnt @ and Hospiglu.getSemaphore()
        newModel = @menuItem.model.clone()
        newModel.set('properties', _.clone(@menuItem.model.get('properties')))
        newModel.unset('id')
        newModel.set('in_menu', false)
        newModel.set('start_shape_id', @connection.from.model.get('id'))
        newModel.set('end_shape_id', @connection.to.model.get('id'))
        @menuItem.model.collection.create newModel
        Hospiglu.selectedMenuItem?.remove()
        delete Hospiglu.selectedMenuItem
      @connection.line.remove()
      @connection.bg?.remove()
      @connection.target.remove()
      delete @connection
      @.remove()

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

    initEditGesture: ->
      @gestureStart = new Date().getTime()

    detectEditGesture: ->
      return if Hospiglu.selectedMenuItem?
      if Hospiglu.getSemaphore()
        duration = new Date().getTime() - @gestureStart
        distance = Math.sqrt(Math.pow(@dx, 2) + Math.pow(@dy, 2))
        if duration > 500 and distance == 0
          @view.editText.apply(@, arguments)

    editText: ->
      $('#editor').modal()




