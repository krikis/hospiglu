Hospiglu.module "Views.Connections", ->
  class @IndexView extends Marionette.CollectionView
    itemView: Hospiglu.Views.Connections.ConnectionView
