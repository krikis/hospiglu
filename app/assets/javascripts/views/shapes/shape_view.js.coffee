Hospiglu.module "Views.Shapes", ->
  class @ShapeView extends Marionette.ItemView
    drag: (x, y, event)->
      shape = Hospiglu.Views.Shapes.ShapeView::createShape(@model, @paper)
      shape.events[0].f.call shape, event

    render: ->
      paper = @options.paper
      if paper.isMenu? == @model.get('in_menu')
        @shape = @createShape(@model, paper, paper.isMenu?)
        @shape.drag null, @drag if paper.isMenu?
        @model.el = @shape
        @

    createShape: (model, paper, menu) ->
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
      color = Raphael.getColor()
      @shape.attr
        fill: color
        stroke: color
        'fill-opacity': 0
        'stroke-width': 2
        cursor: 'move'
      @shape.drag(paper.move, paper.dragger, paper.up) unless menu
      console.log @shape
      @shape

    onClose: ->
      @shape?.remove()
