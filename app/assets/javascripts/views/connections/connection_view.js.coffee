Hospiglu.module "Views.Connections", ->
  class @ConnectionView extends Marionette.ItemView
    render: ->
      paper = @options.paper
      if paper.isMenu? == @model.get('in_menu')
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
            target
            target = paper.path("M,#{connectionProperties.x.toFixed(3)},\
                                   #{connectionProperties.y.toFixed(3)},\
                                 C,#{connectionProperties.cx.toFixed(3)},\
                                   #{connectionProperties.cy.toFixed(3)},\
                                   #{connectionProperties.cx2.toFixed(3)},\
                                   #{connectionProperties.cy2.toFixed(3)},\
                                   #{connectionProperties.x2.toFixed(3)},\
                                   #{connectionProperties.y2.toFixed(3)}")
            target.attr
              stroke: '#333'
              fill: 'none'
              'stroke-width': 10
              cursor: 'move'
            if _.isString connectionProperties.background_color
              background = paper.path("M,#{connectionProperties.x.toFixed(3)},\
                                         #{connectionProperties.y.toFixed(3)},\
                                       C,#{connectionProperties.cx.toFixed(3)},\
                                         #{connectionProperties.cy.toFixed(3)},\
                                         #{connectionProperties.cx2.toFixed(3)},\
                                         #{connectionProperties.cy2.toFixed(3)},\
                                         #{connectionProperties.x2.toFixed(3)},\
                                         #{connectionProperties.y2.toFixed(3)}")
              background.attr
                stroke: connectionProperties.background_color.split("|")[0]
                fill: 'none'
                'stroke-width': (connectionProperties.background_color.split("|")[1] || 3)
                cursor: 'move'
            connection = paper.path("M,#{connectionProperties.x.toFixed(3)},\
                                       #{connectionProperties.y.toFixed(3)},\
                                     C,#{connectionProperties.cx.toFixed(3)},\
                                       #{connectionProperties.cy.toFixed(3)},\
                                       #{connectionProperties.cx2.toFixed(3)},\
                                       #{connectionProperties.cy2.toFixed(3)},\
                                       #{connectionProperties.x2.toFixed(3)},\
                                       #{connectionProperties.y2.toFixed(3)}")
            connection.attr
              stroke: connectionProperties.line_color
              fill: 'none'
              cursor: 'move'
      @

    onClose: ->
      @connection?.line.remove()

