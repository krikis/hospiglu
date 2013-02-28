Hospiglu.module "Models", ->
  class @Shape extends Backbone.Model
    paramRoot: 'shape'

    defaults: {}

Hospiglu.module "Collections", ->
  class @ShapesCollection extends Backbone.Collection
    model: Hospiglu.Models.Shape
    url: '/shapes'
