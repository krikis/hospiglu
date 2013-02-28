Hospiglu.Views.Shapes ||= {}

class Hospiglu.Views.Shapes.ShowView extends Backbone.View
  template: JST["backbone/templates/shapes/show"]

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
