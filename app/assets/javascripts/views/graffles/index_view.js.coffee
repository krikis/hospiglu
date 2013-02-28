Hospiglu.module "Views.Graffles", ->
  class @IndexView extends Backbone.View
    template: JST["backbone/templates/graffles/index"]

    initialize: () ->
      @options.graffles.bind('reset', @addAll)

    addAll: () =>
      @options.graffles.each(@addOne)

    addOne: (graffle) =>
      view = new Hospiglu.Views.Graffles.GraffleView({model : graffle})
      @$("tbody").append(view.render().el)

    render: =>
      @$el.html(@template(graffles: @options.graffles.toJSON() ))
      @addAll()

      return this
