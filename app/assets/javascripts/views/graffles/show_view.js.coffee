Hospiglu.module "Views.Graffles", ->
  class @ShowView extends Marionette.CompositeView
    template: 'graffles/show'
    onRender: ->
      graffleProperties = @model.get('properties')
      @svg = Raphael('container',
                     graffleProperties.width,
                     graffleProperties.height)
