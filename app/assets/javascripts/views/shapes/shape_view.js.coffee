Hospiglu.module "Views.Shapes", ->
  class @ShapeView extends Marionette.ItemView
    mousedownHandler: (event) ->
      newModel = @model.clone()
      newModel.unset('id')
      newModel.set('in_menu', false)
      newModel.event = event
      @model.collection.add newModel

    render: ->
      paper = @options.paper
      @shape = @createShape(@model, paper)
      @shape.events[0].f.call @shape, @model.event if @model.event
      @shape.mousedown @mousedownHandler if @model.get('in_menu')
      @model.el = @shape
      @

    createShape: (model, paper) ->
      in_menu = model.get('in_menu')
      shapeProperties = model.get('properties')
      @shape = paper[shapeProperties.shape_type].call(
        paper,
        shapeProperties.x,
        shapeProperties.y,
        shapeProperties.width,
        shapeProperties.height,
        shapeProperties.border_radius
      )
      @shape.model = model
      color = if in_menu
        '#fff'
      else
        Raphael.getColor()
      @shape.attr
        fill: color
        stroke: color
        'fill-opacity': 0
        'stroke-width': 2
        cursor: 'move'
      unless in_menu
        @shape.drag(paper.move, paper.dragger, paper.up)
      @shape

    onClose: ->
      @shape?.remove()
