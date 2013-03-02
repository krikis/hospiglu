Hospiglu.module "Views.Graffles", ->
  class @ShowView extends Marionette.CompositeView
    template: 'graffles/show'
    onDomRefresh: ->
      graffleProperties = @model.get('properties')
      paper = Raphael('container', '100%', '90%')
      shapesView = new Hospiglu.Views.Shapes
                               .IndexView(collection: @options.shapes, paper: paper)
      Hospiglu.shapes.show(shapesView)
      connectionsView = new Hospiglu.Views.Connections
                                    .IndexView(collection: @options.connections, paper: paper)
      Hospiglu.connections.show(connectionsView)
