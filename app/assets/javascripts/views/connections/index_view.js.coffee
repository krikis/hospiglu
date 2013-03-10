Hospiglu.module "Views.Connections", ->
  class @IndexView extends Marionette.CollectionView
    getItemView: -> Hospiglu.Views.Connections.ConnectionView
    itemViewOptions: ->
      scale: @options.scale
      noEditing: @options.noEditing
      paper: @options.paper

