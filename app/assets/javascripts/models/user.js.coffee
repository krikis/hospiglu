class Hospiglu.Models.User extends Backbone.Model
  paramRoot: 'user'

  defaults:

class Hospiglu.Collections.UsersCollection extends Backbone.Collection
  model: Hospiglu.Models.User
  url: '/users'
