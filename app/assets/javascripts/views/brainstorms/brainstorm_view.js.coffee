Hospiglu.Views.Brainstorms ||= {}

class Hospiglu.Views.Brainstorms.BrainstormView extends Backbone.View
  template: JST["backbone/templates/brainstorms/brainstorm"]

  events:
    "click .destroy" : "destroy"

  tagName: "tr"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
