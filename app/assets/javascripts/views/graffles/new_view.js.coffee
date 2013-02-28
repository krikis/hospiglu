Hospiglu.Views.Graffles ||= {}

class Hospiglu.Views.Graffles.NewView extends Backbone.View
  template: JST["backbone/templates/graffles/new"]

  events:
    "submit #new-graffle": "save"

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
      success: (graffle) =>
        @model = graffle
        window.location.hash = "/#{@model.id}"

      error: (graffle, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
