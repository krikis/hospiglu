Hospiglu.module "Views.Graffles", ->
  class @IndexView extends Marionette.CompositeView
    getItemView: -> Hospiglu.Views.Graffles.GraffleView
    template: 'graffles/index'

