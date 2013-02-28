Hospiglu.module "Views.Shapes", ->
  class @IndexView extends Backbone.View
    template: JST["backbone/templates/shapes/index"]

    initialize: () ->
      @options.shapes.bind('reset', @addAll)

    addAll: () =>
      @options.shapes.each(@addOne)

    addOne: (shape) =>
      view = new Hospiglu.Views.Shapes.ShapeView({model : shape})
      @$("tbody").append(view.render().el)

    render: =>
      @$el.html(@template(shapes: @options.shapes.toJSON() ))
      @addAll()

      return this
