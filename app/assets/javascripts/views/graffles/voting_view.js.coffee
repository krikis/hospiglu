Hospiglu.module "Views.Graffles", ->
  class @VotingView extends Marionette.CompositeView
    template: 'graffles/voting'
    itemViewContainer: '.voting'
    getItemView: -> Hospiglu.Views.Graffles.ShowView

    itemViewOptions: ->
      height: '30%'
      scale: 0.5

    onBeforeRender: ->
      _.each @collection.models, (graffle) ->
        properties = graffle.get('properties')
        properties.noEditing = true
        graffle.set properties: properties

    onClose: ->
      _.each @collection.models, (graffle) ->
        properties = graffle.get('properties')
        delete properties.noEditing
        graffle.set properties: properties


