Hospiglu.Views.Brainstorms ||= {}

class Hospiglu.Views.Brainstorms.ShowView extends Backbone.View
  template: JST["backbone/templates/brainstorms/show"]

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
