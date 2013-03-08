Hospiglu.Views.Brainstorms ||= {}

class Hospiglu.Views.Brainstorms.EditView extends Backbone.View
  template: JST["backbone/templates/brainstorms/edit"]

  events:
    "submit #edit-brainstorm": "update"

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success: (brainstorm) =>
        @model = brainstorm
        window.location.hash = "/#{@model.id}"
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
