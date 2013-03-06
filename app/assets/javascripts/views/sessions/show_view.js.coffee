Hospiglu.Views.Sessions ||= {}

class Hospiglu.Views.Sessions.ShowView extends Backbone.View
  template: JST["backbone/templates/sessions/show"]

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
