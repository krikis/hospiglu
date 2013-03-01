Hospiglu.module "Models", ->
  class @Shape extends Backbone.Model
    paramRoot: 'shape'
    defaults: {}

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
