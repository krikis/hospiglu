Hospiglu.module "Views.Shapes", ->
  class @NewView extends Backbone.View
    template: JST["backbone/templates/shapes/new"]

    events:
      "submit #new-shape": "save"

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
        success: (shape) =>
          @model = shape
          window.location.hash = "/#{@model.id}"

        error: (shape, jqXHR) =>
          @model.set({errors: $.parseJSON(jqXHR.responseText)})
      )

    render: ->
      @$el.html(@template(@model.toJSON() ))

      this.$("form").backboneLink(@model)

      return this
