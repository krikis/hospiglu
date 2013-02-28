Hospiglu.Views.Connections ||= {}

class Hospiglu.Views.Connections.NewView extends Backbone.View
  template: JST["backbone/templates/connections/new"]

  events:
    "submit #new-connection": "save"

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
      success: (connection) =>
        @model = connection
        window.location.hash = "/#{@model.id}"

      error: (connection, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
