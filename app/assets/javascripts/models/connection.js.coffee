class Hospiglu.Models.Connection extends Backbone.Model
  paramRoot: 'connection'

  defaults:

class Hospiglu.Collections.ConnectionsCollection extends Backbone.Collection
  model: Hospiglu.Models.Connection
  url: '/connections'
