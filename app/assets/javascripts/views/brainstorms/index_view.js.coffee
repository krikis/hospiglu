Hospiglu.Views.Brainstorms ||= {}

class Hospiglu.Views.Brainstorms.IndexView extends Backbone.View
  template: JST["backbone/templates/brainstorms/index"]

  initialize: () ->
    @options.brainstorms.bind('reset', @addAll)

  addAll: () =>
    @options.brainstorms.each(@addOne)

  addOne: (brainstorm) =>
    view = new Hospiglu.Views.Brainstorms.BrainstormView({model : brainstorm})
    @$("tbody").append(view.render().el)

  render: =>
    @$el.html(@template(brainstorms: @options.brainstorms.toJSON() ))
    @addAll()

    return this
