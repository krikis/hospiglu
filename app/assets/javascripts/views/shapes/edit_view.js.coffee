Hospiglu.Views.Shapes ||= {}

class Hospiglu.Views.Shapes.EditView extends Backbone.View
  template: JST["backbone/templates/shapes/edit"]

  events:
    "submit #edit-shape": "update"

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success: (shape) =>
        @model = shape
        window.location.hash = "/#{@model.id}"
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
