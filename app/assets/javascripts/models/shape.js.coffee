Hospiglu.module "Models", ->
  class @Shape extends Backbone.Model
    outgoingConnections: ->
      Hospiglu.router.connections.where(start_shape_id: @id)

    incomingConnections: ->
      Hospiglu.router.connections.where(end_shape_id: @id)

Hospiglu.module "Collections", ->
  class @ShapesCollection extends Backbone.Collection
    model: Hospiglu.Models.Shape
    url: '/shapes'
