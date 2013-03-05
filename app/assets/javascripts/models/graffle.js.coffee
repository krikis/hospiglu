Hospiglu.module "Models", ->
  class @Graffle extends Backbone.Model

Hospiglu.module "Collections", ->
  class @GrafflesCollection extends Backbone.Collection
    model: Hospiglu.Models.Graffle
    url: '/graffles'
