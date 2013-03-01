Hospiglu.module "Views.Connections", ->
  class @IndexView extends Marionette.CollectionView
    getItemView: -> Hospiglu.Views.Connections.ConnectionView
    itemViewOptions: ->
      raphael: @options.raphael

