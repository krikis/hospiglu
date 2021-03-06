Hospiglu.module "Views.Shapes", ->
  class @ShapeView extends Marionette.ItemView
    modelEvents:
      'change:details': 'render'

    render: ->
      @shape?.text?.remove()
      @shape?.remove()
      @options.scale ||= 1
      unless @options.noEditing and @model.get('in_menu')
        paper = @options.paper
        @shape = @createShape(@model, paper)
        @shape.model = @model
        @shape.view = @
        @shape.collection = @model.collection
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
      x = shapeProperties.x * @options.scale
      y = if not model.collection or inMenu or @options.noEditing
        shapeProperties.y * @options.scale
      else
        shapeProperties.y * @options.scale + 100 # move below menu
      width = shapeProperties.width * @options.scale
      height = shapeProperties.height * @options.scale
      radius = shapeProperties.border_radius * @options.scale
      if label = shapeProperties.label
        [textX, textY] = if shapeProperties.shape_type == 'rect'
          [x + (width / 2), y + (height / 2)]
        else
          [x, y]
        fontSize = 15 * @options.scale
        text = paper.text(textX, textY, label).attr(fill: '#fff', font: "#{fontSize}px \"Helvetica Neue\"")
        textWidth = text.node.offsetWidth + (20 * @options.scale)
        textWidth = textWidth / 2 unless shapeProperties.shape_type == 'rect'
      shapeWidth = Math.max(width, textWidth || 0)
      shapeX = if shapeProperties.shape_type == 'rect'
        x + (width / 2) - (shapeWidth / 2)
      else
        x
      shape = paper[shapeProperties.shape_type].call(paper, shapeX, y, shapeWidth, height, radius)
      model.el = shape
      shape.text = text
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
      if shapeProperties.description?.length > 0 or (shapeProperties.label?.length > 0 and @options.noEditing)
        $(shape.node).attr('title', shapeProperties.label)
        $(shape.node).attr('data-content', shapeProperties.description)
        $(shape.node).attr('href', '#')
        placement = if @options.noEditing then 'bottom' else 'top'
        $(shape.node).popover placement: placement, container: 'body', trigger: 'hover'
      @redrawConnections(model, paper)
      if inMenu
        shape.mouseover -> @glowSet = @glow(color: '#0088cc', opacity: 1)
        shape.mouseout -> @glowSet?.remove()
      else if not @options.noEditing
        shape.mousedown(@initDummy)
        shape.drag(@move, @down, @up)
        shape.mouseup(@handleDelete)
        shape.dblclick(@editText)
      shape

    redrawConnections: (model, paper) ->
      Hospiglu.connectionsCallbacks.add =>
        _.each model.outgoingConnections(), (connection) =>
          paper.connection connection.el if connection.el
        _.each model.incomingConnections(), (connection) =>
          paper.connection connection.el if connection.el
      paper.safari()

    onClose: ->
      @shape?.text?.remove()
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
      $('.popover').hide()
      @dx = Math.max Math.abs(dx), @dx || 0
      @dy = Math.max Math.abs(dy), @dy || 0
      @x = @ox + dx
      @y = @oy + dy
      if @type is "rect"
        @y = if @model.collection? and @y < 100 then 100 else @y
        if @text
          @text.attr
            x: @x + (@attr('width') / 2)
            y: @y + (@attr('height') / 2)
        @attr
          x: @x
          y: @y
      else
        @y = if @model.collection? and @y - @attr('ry') < 100
          100 + @attr('ry')
        else
          @y
        if @text
          @text.attr
            x: @x
            y: @y
        @attr
          cx: @x
          cy: @y
      @view.redrawConnections(@model, @paper)

    down: ->
      return if Hospiglu.selectedMenuItem?
      @gestureStart = new Date().getTime()
      @dx = @dy = 0
      @ox = (if @type is "rect" then @attr("x") else @attr("cx"))
      @oy = (if @type is "rect" then @attr("y") else @attr("cy"))
      @animate
        "fill-opacity": .2
      , 500

    up: ->
      return if Hospiglu.selectedMenuItem?
      if Hospiglu.getSemaphore()
        duration = new Date().getTime() - @gestureStart
        distance = Math.sqrt(Math.pow(@dx, 2) + Math.pow(@dy, 2))
        if duration > 500 and distance == 0
          @view.editText.apply(@, arguments)
        else
          model = @model
          collection = @collection
          box = @getBBox()
          [x, y, ox, oy] = [@x, @y, @ox, @oy]
          @remove() unless model.collection?
          if x? and y? and (x isnt ox or y isnt oy)
            shapeProperties = model.get('properties')
            if @type is "rect"
              x += Math.abs(@attr('width') - shapeProperties.width) / 2
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
      dummy.startShape = @model
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
      $('.popover').hide()
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
        newModel.set('start_shape_id', @connection.from.get('id'))
        newModel.set('end_shape_id', @connection.to.get('id'))
        @menuItem.model.collection.create newModel
        Hospiglu.selectedMenuItem?.remove()
        delete Hospiglu.selectedMenuItem
      @connection.line.remove()
      @connection.bg?.remove()
      @connection.target.remove()
      delete @connection
      @.remove()

    snapConnectionTo: (shape) ->
      if @connection? and shape isnt @connection.from.el and
         shape.type isnt 'path' and not shape.model?.get('in_menu')
        clearTimeout @releaseConnection
        @connection.to = shape.model
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

    editText: ->
      $('#editor #save_details').unbind('click')
      $('#editor #save_details').click @view.updateDetails
      $('#editor').unbind('keydown')
      $('#editor').keydown @view.handleKeystroke
      properties = @model.get('properties')
      $('#editor #shape_label').attr('value', properties.label)
      $('#editor #shape_description').attr('value', properties.description)
      $('#editor').modal('show')
      $('#editor').on 'shown', ->
        $('#shape_label').focus()
      $('#editor').on 'hidden', ->
        $('#editor #shape_label').attr('value', null)
        $('#editor #shape_description').attr('value', null)

    handleKeystroke: (event) =>
      if event.keyCode == 13
        @updateDetails(event)

    updateDetails: (event) =>
      event.stopPropagation()
      event.preventDefault()
      properties = @model.get('properties')
      properties.label =  $('#editor #shape_label').attr('value')
      properties.description =  $('#editor #shape_description').attr('value').substring(0, 255)
      @model.save(properties: properties)
      @model.trigger('change:details', @model, {})
      $('#editor').modal('hide')




