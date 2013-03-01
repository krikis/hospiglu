Hospiglu.module "Views.Graffles", ->
  class @ShowView extends Marionette.CompositeView
    template: 'graffles/show'
    onDomRefresh: ->
      graffleProperties = @model.get('properties')
      @raphael = Raphael('menu', '100%', '15%')
      @raphael = Raphael('container', '100%', '70%')
