Hospiglu.module "Views.Graffles", ->
  class @ShowView extends Marionette.CompositeView
    template: 'graffles/show'
    onDomRefresh: ->
      graffleProperties = @model.get('properties')
      menu = Raphael('menu')
      container = Raphael('container')
      shapesView = new Hospiglu.Views.Shapes
                               .IndexView(collection: @options.shapes, raphael: container)
      Hospiglu.shapes.show(shapesView)
      connectionsView = new Hospiglu.Views.Connections
                                    .IndexView(collection: @options.connections, raphael: container)
      Hospiglu.connections.show(connectionsView)
