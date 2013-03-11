Hospiglu.module "Models", ->
  class @Shape extends Backbone.Model
    graffle: ->
      @shapeGraffle ?= Hospiglu.router.graffles.get(@get('graffle_id'))

    outgoingConnections: ->
      @graffle().connections().where(start_shape_id: @id)

    incomingConnections: ->
      @graffle().connections().where(end_shape_id: @id)

Hospiglu.module "Collections", ->
  class @ShapesCollection extends Backbone.Collection
    model: Hospiglu.Models.Shape
    url: '/shapes'
