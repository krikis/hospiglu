Hospiglu.module "Views.Graffles", ->
  class @IndexView extends Marionette.CompositeView
    getItemView: -> Hospiglu.Views.Graffles.GraffleView
    itemViewContainer: "tbody",
    template: 'graffles/index'

