Hospiglu.module "Views.Connections", ->
  class @ConnectionView extends Marionette.ItemView
    render: ->
      @options.scale ||= 1
      paper = @options.paper
      @model.graffle().graffleShapesCallbacks.add =>
        if @model.get('in_menu')
          @createMenuItem(@model, paper) unless @options.noEditing
        else if (startShape = @model.startShape()) and
                (endShape = @model.endShape())
          @connection = @createConnection(@model, startShape, endShape, paper)
          @model.el = @connection
      @

    createConnection: (model, start, end, paper) ->
      connectionProperties = model.get('properties')
      background = connectionProperties.background
      connection = paper.connection(start,
                                    end,
                                    connectionProperties.stroke,
                                    (if background then background.stroke || connectionProperties.stroke),
                                    connectionProperties['stroke-width'] * @options.scale,
                                    (background['stroke-width'] * @options.scale) if background?)
      connection.target.model = @model
      connection.target.mouseup @handleDelete unless @options.noEditing
      connection

    handleDelete: ->
      if Hospiglu.selectedMenuItem?.trash
        @model.destroy()
        Hospiglu.selectedMenuItem.remove()
        delete Hospiglu.selectedMenuItem

    createMenuItem: (model, paper) ->
      connectionProperties = model.get('properties')
      connectionType = connectionProperties.type
      if background = connectionProperties.background
        backgroundType = background.type || connectionType
        @background = paper[backgroundType].call paper, _.extend(
          {}, connectionProperties, background
        )
      @line = paper[connectionType].call paper, connectionProperties
      target = connectionProperties.target || {}
      targetType = target.type || connectionType
      @target = paper[targetType].call paper, _.extend(
        stroke: '#fff'
        'stroke-width': 20
        'stroke-opacity': 0
        fill: '#fff'
        'fill-opacity': 0
        cursor: 'pointer',
        connectionProperties,
        target
      )
      @target.selectColor = connectionProperties.select_color
      @target.mouseover =>
        unless Hospiglu.selectedMenuItem?.model == @model
          @glowSet = (@background || @line).glow(color: '#0088cc', opacity: 1).toBack()
      @target.mouseout => @glowSet?.remove()
      @target.mousedown @selectMenuItem
      @target

    onClose: ->
      @connection?.line.remove()
      @connection?.bg?.remove()
      @connection?.target.remove()
      @background?.remove()
      @line?.remove()
      @target?.remove()

    selectMenuItem: (event) =>
      @glowSet?.remove()
      Hospiglu.selectedMenuItem?.remove()
      Hospiglu.selectedMenuItem = (@background || @line).glow(
        color: @target.selectColor || '#0088cc',
        width: 20, opacity: 1
      )
      Hospiglu.selectedMenuItem.toBack()
      Hospiglu.selectedMenuItem.trash = @model.get('properties').type == 'trashcan'
      Hospiglu.selectedMenuItem.model = @model
      Hospiglu.selectedMenuItem.view = @



