Hospiglu.module "Models", ->
  class @User extends Backbone.Model

Hospiglu.module "Collections", ->
  class @UsersCollection extends Backbone.Collection
    model: Hospiglu.Models.User
    url: '/users'
