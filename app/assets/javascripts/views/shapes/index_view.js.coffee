Hospiglu.module "Views.Shapes", ->
  class @IndexView extends Marionette.CollectionView
    getItemView: -> Hospiglu.Views.Shapes.ShapeView
    itemViewOptions: ->
      raphael: @options.raphael

