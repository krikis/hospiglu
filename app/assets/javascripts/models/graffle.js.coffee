Hospiglu.module "Models", ->
  class @Graffle extends Backbone.Model
    shapes: ->
      shapes = new Hospiglu.Collections.ShapesCollection()
      Hospiglu.shapesCallbacks.add =>
        shapes.reset Hospiglu.router.shapes.where(graffle_id: @id)
      shapes

    connections: ->
      connections = new Hospiglu.Collections.ConnectionsCollection()
      Hospiglu.connectionsCallbacks.add =>
        connections.reset Hospiglu.router.connections.where(graffle_id: @id)
      connections



Hospiglu.module "Collections", ->
  class @GrafflesCollection extends Backbone.Collection
    model: Hospiglu.Models.Graffle
    url: '/graffles'
