Hospiglu.module "Routers", ->
  class @GrafflesRouter extends Backbone.Router
    initialize: (options) ->
      @graffles = new Hospiglu.Collections.GrafflesCollection()
      @graffles.reset options.graffles

    routes:
      "new"      : "newGraffle"
      "index"    : "index"
      ":id/edit" : "edit"
      ":id"      : "show"
      ".*"        : "index"

    newGraffle: ->
      @view = new Hospiglu.Views.Graffles.NewView(collection: @graffles)
      $("#graffles").html(@view.render().el)

    index: ->
      @view = new Hospiglu.Views.Graffles.IndexView(graffles: @graffles)
      $("#graffles").html(@view.render().el)

    show: (id) ->
      graffle = @graffles.get(id)

      @view = new Hospiglu.Views.Graffles.ShowView(model: graffle)
      $("#graffles").html(@view.render().el)

    edit: (id) ->
      graffle = @graffles.get(id)

      @view = new Hospiglu.Views.Graffles.EditView(model: graffle)
      $("#graffles").html(@view.render().el)
