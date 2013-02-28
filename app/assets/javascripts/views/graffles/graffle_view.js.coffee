Hospiglu.Views.Graffles ||= {}

class Hospiglu.Views.Graffles.GraffleView extends Backbone.View
  template: JST["backbone/templates/graffles/graffle"]

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
