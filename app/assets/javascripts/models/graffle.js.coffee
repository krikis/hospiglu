class Hospiglu.Models.Graffle extends Backbone.Model
  paramRoot: 'graffle'

  defaults:

class Hospiglu.Collections.GrafflesCollection extends Backbone.Collection
  model: Hospiglu.Models.Graffle
  url: '/graffles'
