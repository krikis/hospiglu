Hospiglu.module "Routers", ->
  class @BrainstormsRouter extends Backbone.Router
    initialize: (options) ->
      @brainstorms = new Hospiglu.Collections.BrainstormsCollection()
      @brainstorms.reset options.brainstorms

    routes:
      "new"      : "newBrainstorm"
      "index"    : "index"
      ":id/edit" : "edit"
      ":id"      : "show"
      ".*"        : "index"

    newBrainstorm: ->
      @view = new Hospiglu.Views.Brainstorms.NewView(collection: @brainstorms)
      $("#brainstorms").html(@view.render().el)

    index: ->
      @view = new Hospiglu.Views.Brainstorms.IndexView(brainstorms: @brainstorms)
      $("#brainstorms").html(@view.render().el)

    show: (id) ->
      brainstorm = @brainstorms.get(id)

      @view = new Hospiglu.Views.Brainstorms.ShowView(model: brainstorm)
      $("#brainstorms").html(@view.render().el)

    edit: (id) ->
      brainstorm = @brainstorms.get(id)

      @view = new Hospiglu.Views.Brainstorms.EditView(model: brainstorm)
      $("#brainstorms").html(@view.render().el)
