Hospiglu.module "Models", ->
  class @Connection extends Backbone.Model
    paramRoot: 'connection'

    defaults: {}

Hospiglu.module "Collections", ->
  class @ConnectionsCollection extends Backbone.Collection
    model: Hospiglu.Models.Connection
    url: '/connections'
