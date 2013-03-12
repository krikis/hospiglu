Hospiglu.module "Views.Graffles", ->
  class @VoteView extends Marionette.CompositeView
    template: 'graffles/vote'
    itemViewContainer: '.vote'
    getItemView: -> Hospiglu.Views.Graffles.ShowView

    itemViewOptions: ->
      noEditing: true
      height: '30%'
      scale: 0.5

    initialize: ->
      properties = @model.get('properties')
      properties.noEditing = true
      properties.userOnly = true
      @model.set properties: properties
      @collection = new Hospiglu.Collections.GrafflesCollection [@model]

    onClose: ->
      properties = @model.get('properties')
      delete properties.noEditing
      @model.set properties: properties

