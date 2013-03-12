Hospiglu.module "Views.Graffles", ->
  class @VotingView extends Marionette.CompositeView
    template: 'graffles/voting'
    itemViewContainer: '.voting'
    getItemView: -> Hospiglu.Views.Graffles.ShowView

    itemViewOptions: ->
      noEditing: true
      userOnly: true
      height: '30%'
      scale: 0.5

    initialize: ->
      _.each @collection.models, (graffle) ->
        properties = graffle.get('properties')
        properties.noEditing = true
        properties.userOnly = true
        graffle.set properties: properties

    onClose: ->
      _.each @collection.models, (graffle) ->
        properties = graffle.get('properties')
        delete properties.noEditing
        delete properties.userOnly
        graffle.set properties: properties


