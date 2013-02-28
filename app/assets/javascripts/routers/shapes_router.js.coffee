class Hospiglu.Routers.ShapesRouter extends Backbone.Router
  initialize: (options) ->
    @shapes = new Hospiglu.Collections.ShapesCollection()
    @shapes.reset options.shapes

  routes:
    "new"      : "newShape"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newShape: ->
    @view = new Hospiglu.Views.Shapes.NewView(collection: @shapes)
    $("#shapes").html(@view.render().el)

  index: ->
    @view = new Hospiglu.Views.Shapes.IndexView(shapes: @shapes)
    $("#shapes").html(@view.render().el)

  show: (id) ->
    shape = @shapes.get(id)

    @view = new Hospiglu.Views.Shapes.ShowView(model: shape)
    $("#shapes").html(@view.render().el)

  edit: (id) ->
    shape = @shapes.get(id)

    @view = new Hospiglu.Views.Shapes.EditView(model: shape)
    $("#shapes").html(@view.render().el)
