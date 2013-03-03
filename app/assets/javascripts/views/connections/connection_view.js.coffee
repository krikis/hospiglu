Hospiglu.module "Views.Connections", ->
  class @ConnectionView extends Marionette.ItemView
    mousedown: (event)->
      console.log event.target

    render: ->
      paper = @options.paper
      connectionProperties = @model.get('properties')
      Hospiglu.shapesCallbacks.add =>
        if (startShape = @model.startShape()) and
           (endShape = @model.endShape())
          @connection = paper.connection(startShape.el,
                                         endShape.el,
                                         connectionProperties.line_color,
                                         connectionProperties.background_color)
          @model.el = @connection
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
            strokeWidth: 20
            strokeOpacity: 0
            cursor: 'pointer',
            connectionProperties
          )
          target.mousedown @mousedown
      @

    onClose: ->
      @connection?.line.remove()

