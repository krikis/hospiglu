class Hospiglu.Models.Shape extends Backbone.Model
  paramRoot: 'shape'

  defaults:

class Hospiglu.Collections.ShapesCollection extends Backbone.Collection
  model: Hospiglu.Models.Shape
  url: '/shapes'
