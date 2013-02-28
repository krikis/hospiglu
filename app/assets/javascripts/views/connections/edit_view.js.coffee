Hospiglu.module "Views.Connections", ->
  class @EditView extends Backbone.View
    template: JST["backbone/templates/connections/edit"]

    events:
      "submit #edit-connection": "update"

    update: (e) ->
      e.preventDefault()
      e.stopPropagation()

      @model.save(null,
        success: (connection) =>
          @model = connection
          window.location.hash = "/#{@model.id}"
      )

    render: ->
      @$el.html(@template(@model.toJSON() ))

      this.$("form").backboneLink(@model)

      return this
