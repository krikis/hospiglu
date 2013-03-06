Hospiglu.module "Views.Graffles", ->
  class @IndexView extends Marionette.CompositeView
    getItemView: -> Hospiglu.Views.Graffles.GraffleView

    template: 'graffles/index'
    itemViewContainer: 'ul.nav'

    itemViewOptions: ->
      current: @options.current

    onDomRefresh: ->
      # $('.dropdown-toggle').dropdown()
