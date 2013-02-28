Hospiglu.Views.Connections ||= {}

class Hospiglu.Views.Connections.ShowView extends Backbone.View
  template: JST["backbone/templates/connections/show"]

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
