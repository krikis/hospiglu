Hospiglu.module "Views.Shapes", ->
  class @IndexView extends Marionette.CollectionView
    collectionEvents:
      'add': 'addItem'

    getItemView: -> Hospiglu.Views.Shapes.ShapeView

    itemViewOptions: ->
      paper: @options.paper

    addItem: (item)->
      ItemView = @getItemView(item);
      @addItemView(item, ItemView);

