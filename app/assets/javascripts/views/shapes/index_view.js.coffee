Hospiglu.module "Views.Shapes", ->
  class @IndexView extends Marionette.CollectionView

    getItemView: -> Hospiglu.Views.Shapes.ShapeView

    itemViewOptions: ->
      scale: @options.scale
      noEditing: @options.noEditing
      paper: @options.paper

