Hospiglu.module "Views.Connections", ->
  class @ConnectionView extends Marionette.ItemView
    render: ->
      paper = @options.paper
      if paper.isMenu? == @model.get('menu_id')?
        connectionProperties = @model.get('properties')
        Hospiglu.shapesCallbacks.add =>
          @connection = paper.connection(@model.startShape().el,
                                         @model.endShape().el,
                                         connectionProperties.line_color,
                                         connectionProperties.background_color)
          @model.el = @connection
      @

    onClose: ->
      @connection?.line.remove()

