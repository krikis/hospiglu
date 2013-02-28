Hospiglu.Views.Graffles ||= {}

class Hospiglu.Views.Graffles.EditView extends Backbone.View
  template: JST["backbone/templates/graffles/edit"]

  events:
    "submit #edit-graffle": "update"

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success: (graffle) =>
        @model = graffle
        window.location.hash = "/#{@model.id}"
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
