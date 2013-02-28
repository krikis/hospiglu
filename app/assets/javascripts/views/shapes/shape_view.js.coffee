Hospiglu.module "Views.Shapes", ->
  class @ShapeView extends Backbone.View
    template: JST["backbone/templates/shapes/shape"]

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