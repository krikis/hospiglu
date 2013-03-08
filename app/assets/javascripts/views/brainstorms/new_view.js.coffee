Hospiglu.Views.Brainstorms ||= {}

class Hospiglu.Views.Brainstorms.NewView extends Backbone.View
  template: JST["backbone/templates/brainstorms/new"]

  events:
    "submit #new-brainstorm": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (brainstorm) =>
        @model = brainstorm
        window.location.hash = "/#{@model.id}"

      error: (brainstorm, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
