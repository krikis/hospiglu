Hospiglu.module "Views.Graffles", ->
  class @ShowView extends Backbone.View
    template: JST["backbone/templates/graffles/show"]

    render: ->
      @$el.html(@template(@model.toJSON() ))
      return this
