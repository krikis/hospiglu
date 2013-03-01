Hospiglu.module "Views.Shapes", ->
  class @IndexView extends Marionette.CollectionView
    getItemView: -> Hospiglu.Views.Shapes.ShapeView
    itemViewOptions: ->
      paper: @options.paper

