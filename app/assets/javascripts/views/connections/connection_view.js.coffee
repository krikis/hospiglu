Hospiglu.module "Views.Connections", ->
  class @ConnectionView extends Marionette.ItemView
    render: ->
      paper = @options.paper
      connectionProperties = @model.get('properties')
      Hospiglu.shapesCallbacks.add =>
        if (startShape = @model.startShape()) and
           (endShape = @model.endShape())
          @model.el = @createConnection(@model, startShape.el, endShape.el, paper)
        else if connectionProperties.x?
          connection = @createMenuItem(@model, paper)
      @

    createConnection: (model, start, end, paper) ->
      connectionProperties = model.get('properties')
      connection = paper.connection(start,
                                    end,
                                    connectionProperties.line_color,
                                    connectionProperties.background_color,
                                    connectionProperties.background_stroke_width)
      connection

    createMenuItem: (model, paper) ->
      connectionProperties = model.get('properties')
      if connectionProperties.background_color
        @background = paper.curvedPath _.extend(
          stroke: connectionProperties.background_color
          strokeWidth: connectionProperties.background_stroke_width,
          connectionProperties
        )
      @line = paper.curvedPath _.extend(
        stroke: connectionProperties.line_color,
        connectionProperties
      )
      @target = paper.curvedPath _.extend(
        stroke: '#fff'
        strokeWidth: 20
        strokeOpacity: 0
        cursor: 'pointer',
        connectionProperties
      )
      @target.mouseover =>
        unless Hospiglu.selectedMenuItem?.model == @model
          @glowSet = (@background || @line).glow(color: '#0088cc', opacity: 1).toBack()
      @target.mouseout => @glowSet?.remove()
      @target.mousedown @mousedown
      @target

    onClose: ->
      @connection?.line.remove()
      @connection?.bg?.remove()
      @background?.remove()
      @line?.remove()
      @target?.remove()

    mousedown: (event) =>
      @glowSet?.remove()
      Hospiglu.selectedMenuItem?.remove()
      Hospiglu.selectedMenuItem = @target.glow(color: '#0088cc', width: 10, opacity: 1)
      Hospiglu.selectedMenuItem.toBack()
      Hospiglu.selectedMenuItem.model = @model
      Hospiglu.selectedMenuItem.view = @



