Hospiglu.module "Models", ->
  class @Connection extends Backbone.Model
    startShape: ->
      Hospiglu.router.shapes.get(@get('start_shape_id'))

    endShape: ->
      Hospiglu.router.shapes.get(@get('end_shape_id'))

Hospiglu.module "Collections", ->
  class @ConnectionsCollection extends Backbone.Collection
    model: Hospiglu.Models.Connection
    url: '/connections'
