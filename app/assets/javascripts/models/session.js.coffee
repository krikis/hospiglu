class Hospiglu.Models.Session extends Backbone.Model
  paramRoot: 'session'

  defaults:

class Hospiglu.Collections.SessionsCollection extends Backbone.Collection
  model: Hospiglu.Models.Session
  url: '/sessions'
