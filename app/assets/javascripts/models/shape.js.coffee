Hospiglu.module "Models", ->
  class @Shape extends Backbone.Model
    outgoingConnections: ->
      connections = Hospiglu.router.connections
      _.select connections.models, (connection) =>
        connection.get('start_shape_id') == @get('id')

    incomingConnections: ->
      connections = Hospiglu.router.connections
      _.select connections.models, (connection) =>
        connection.get('end_shape_id') == @get('id')


Hospiglu.module "Collections", ->
  class @ShapesCollection extends Backbone.Collection
    model: Hospiglu.Models.Shape
    url: '/shapes'
