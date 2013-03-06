Hospiglu.Views.Sessions ||= {}

class Hospiglu.Views.Sessions.EditView extends Backbone.View
  template: JST["backbone/templates/sessions/edit"]

  events:
    "submit #edit-session": "update"

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success: (session) =>
        @model = session
        window.location.hash = "/#{@model.id}"
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
