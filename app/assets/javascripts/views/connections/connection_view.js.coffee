Hospiglu.module "Views.Connections", ->
  class @ConnectionView extends Marionette.ItemView
    mousedown: (event) ->
      @glowSet.remove()
      Hospiglu.selectedMenuItem?.remove()
      Hospiglu.selectedMenuItem = @glow(color: '#0088cc', width: 10, opacity: 1)
      Hospiglu.selectedMenuItem.toBack()
      Hospiglu.selectedMenuItem.menuItem = @

    render: ->
      paper = @options.paper
      connectionProperties = @model.get('properties')
      Hospiglu.shapesCallbacks.add =>
        if (startShape = @model.startShape()) and
           (endShape = @model.endShape())
          connection = paper.connection(startShape.el,
                                        endShape.el,
                                        connectionProperties.line_color,
                                        connectionProperties.background_color)
          @model.el = connection
        else if connectionProperties.x?
          if connectionProperties.background_color
            background = paper.curvedPath _.extend(
              stroke: connectionProperties.background_color
              strokeWidth: connectionProperties.background_stroke_width,
              connectionProperties
            )
          connection = paper.curvedPath _.extend(
            stroke: connectionProperties.line_color,
            connectionProperties
          )
          target = paper.curvedPath _.extend(
            stroke: '#fff'
            strokeWidth: 20
            strokeOpacity: 0
            cursor: 'pointer',
            connectionProperties
          )
          target.mouseover ->
            unless Hospiglu.selectedMenuItem?.menuItem == @
              @glowSet = (background || connection).glow(color: '#0088cc', opacity: 1).toBack()
          target.mouseout -> @glowSet?.remove()
          target.mousedown @mousedown
      @

    onClose: ->
      @connection?.line.remove()

