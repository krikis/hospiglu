Hospiglu.module "Views.Shapes", ->
  class @ShapeView extends Marionette.ItemView
    render: ->
      svg = @options.svg
      shapeProperties = @model.get('properties')
      console.log shapeProperties
      console.log svg[shapeProperties.shape_type]
      svg[shapeProperties.shape_type].call(
        svg,
        shapeProperties.x,
        shapeProperties.y,
        shapeProperties.width,
        shapeProperties.height,
        shapeProperties.border_radius
      )
      @
