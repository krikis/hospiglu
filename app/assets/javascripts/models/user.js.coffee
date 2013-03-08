class Hospiglu.Models.User extends Backbone.Model

class Hospiglu.Collections.UsersCollection extends Backbone.Collection
  model: Hospiglu.Models.User
  url: '/users'
