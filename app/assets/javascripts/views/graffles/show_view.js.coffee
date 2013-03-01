Hospiglu.module "Views.Graffles", ->
  class @ShowView extends Marionette.CompositeView
    template: 'graffles/show'
    onDomRefresh: ->
      graffleProperties = @model.get('properties')
      menu = Raphael('menu')
      menu.isMenu = true
      shapesView = new Hospiglu.Views.Shapes
                               .IndexView(collection: @options.shapes, paper: menu)
      Hospiglu.menuShapes.show(shapesView)
      connectionsView = new Hospiglu.Views.Connections
                                    .IndexView(collection: @options.connections, paper: menu)
      Hospiglu.menuConnections.show(connectionsView)
      container = Raphael('container')
      shapesView = new Hospiglu.Views.Shapes
                               .IndexView(collection: @options.shapes, paper: container)
      Hospiglu.shapes.show(shapesView)
      connectionsView = new Hospiglu.Views.Connections
                                    .IndexView(collection: @options.connections, paper: container)
      Hospiglu.connections.show(connectionsView)
