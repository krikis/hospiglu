Hospiglu.module "Models", ->
  class @Graffle extends Backbone.Model
    getContainer: ->
      @get('graffle_type') || "container#{@get('user_id')}"

    shapes: ->
      shapes = new Hospiglu.Collections.ShapesCollection()
      Hospiglu.shapesCallbacks.add =>
        shapes.reset _.map(Hospiglu.router.shapes.where(graffle_id: @id), (shape) ->
          shape.collection = shapes
          shape
        )
      shapes

    connections: ->
      connections = new Hospiglu.Collections.ConnectionsCollection()
      Hospiglu.connectionsCallbacks.add =>
        connections.reset _.map(Hospiglu.router.connections.where(graffle_id: @id), (connection) ->
          connection.collection = connections
          connection
        )
      connections



Hospiglu.module "Collections", ->
  class @GrafflesCollection extends Backbone.Collection
    model: Hospiglu.Models.Graffle
    url: '/graffles'
