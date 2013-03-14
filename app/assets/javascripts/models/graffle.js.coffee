Hospiglu.module "Models", ->
  class @Graffle extends Backbone.Model
    initialize: ->
      @graffleShapesCallbacks = new Marionette.Callbacks()

    getContainer: ->
      @get('graffle_type') || "container#{@get('user_id')}"

    averageVote: ->
      if votes = @get('properties').votes
        sum = _.reduce votes, ((memo, value) ->
          memo + value
        ), 0
        sum / _.values(votes).length

    shapes: ->
      return @shapesCollection if @shapesCollection?
      @shapesCollection = new Hospiglu.Collections.ShapesCollection()
      Hospiglu.shapesCallbacks.add =>
        @shapesCollection.reset _.map(Hospiglu.router.shapes.where(graffle_id: @id), (shape) =>
          shape.collection = @shapesCollection
          shape
        )
        @graffleShapesCallbacks.run()
      @shapesCollection

    connections: ->
      return @connectionsCollection if @connectionsCollection?
      @connectionsCollection = new Hospiglu.Collections.ConnectionsCollection()
      Hospiglu.connectionsCallbacks.add =>
        @connectionsCollection.reset _.map(Hospiglu.router.connections.where(graffle_id: @id), (connection) =>
          connection.collection = @connectionsCollection
          connection
        )
      @connectionsCollection

Hospiglu.module "Collections", ->
  class @GrafflesCollection extends Backbone.Collection
    model: Hospiglu.Models.Graffle
    url: '/graffles'
