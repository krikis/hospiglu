Hospiglu.module "Models", ->
  class @Brainstorm extends Backbone.Model

Hospiglu.module "Collections", ->
  class @BrainstormsCollection extends Backbone.Collection
    model: Hospiglu.Models.Brainstorm
    url: '/brainstorms'
