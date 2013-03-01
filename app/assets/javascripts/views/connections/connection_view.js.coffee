Hospiglu.module "Views.Connections", ->
  class @ConnectionView extends Marionette.ItemView
    render: ->
      raphael = @options.raphael
      connectionProperties = @model.get('properties')
      Hospiglu.shapesCallbacks.add =>
        @connection = raphael.connection(@model.startShape().el,
                                         @model.endShape().el,
                                         connectionProperties.line_color,
                                         connectionProperties.background_color)
        @model.el = @connection
      @

    onClose: ->
      @connection?.line.remove()

