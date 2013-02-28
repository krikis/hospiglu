Hospiglu.module "Views.Connections", ->
  class @ConnectionView extends Backbone.View
    template: JST["backbone/templates/connections/connection"]

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
