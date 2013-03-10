Hospiglu.module "Models", ->
  class @User extends Backbone.Model
    yourDepartmentGraffle: ->
      _.first Hospiglu.router.graffles.where(user_id: @id)

Hospiglu.module "Collections", ->
  class @UsersCollection extends Backbone.Collection
    model: Hospiglu.Models.User
    url: '/users'
