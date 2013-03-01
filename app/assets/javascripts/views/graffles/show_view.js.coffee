Hospiglu.module "Views.Graffles", ->
  class @ShowView extends Marionette.CompositeView
    template: 'graffles/show'
    onDomRefresh: ->
      graffleProperties = @model.get('properties')
      @raphael = Raphael('container',
                         graffleProperties.width,
                         graffleProperties.height)
