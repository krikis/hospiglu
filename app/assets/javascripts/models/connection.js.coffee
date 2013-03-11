Hospiglu.module "Models", ->
  class @Connection extends Backbone.Model
    graffle: ->
      @connectionGraffle ?= Hospiglu.router.graffles.get(@get('graffle_id'))

    startShape: ->
      @graffle().shapes().get(@get('start_shape_id'))

    endShape: ->
      @graffle().shapes().get(@get('end_shape_id'))

Hospiglu.module "Collections", ->
  class @ConnectionsCollection extends Backbone.Collection
    model: Hospiglu.Models.Connection
    url: '/connections'
