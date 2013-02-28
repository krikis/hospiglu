Hospiglu.module "Views.Graffles", ->
  class @IndexView extends Marionette.CompositeView
    itemView: Hospiglu.Views.Graffles.GraffleView
    itemViewContainer: "tbody",
    template: 'graffles/index'
