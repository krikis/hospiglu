Hospiglu.module "Routers", ->
  class @GrafflesRouter extends Backbone.Router
    initialize: (options) ->
      @graffles = new Hospiglu.Collections.GrafflesCollection()
      @graffles.reset options.graffles
      @shapes = new Hospiglu.Collections.ShapesCollection()
      @shapes.reset options.shapes
      @connections = new Hospiglu.Collections.ConnectionsCollection()
      @connections.reset options.connections

    routes:
      'graffles'          : 'index'
      'graffles/new'      : 'newGraffle'
      'graffles/:id/edit' : 'edit'
      'graffles/:id'      : 'show'
      '.*'                : 'index'

    newGraffle: ->
      @view = new Hospiglu.Views.Graffles.NewView(collection: @graffles)
      $("#graffles").html(@view.render().el)

    index: ->
      graffleList = new Hospiglu.Views.Graffles.IndexView(collection: @graffles)
      Hospiglu.sidebar.show(graffleList)
      graffleView = new Hospiglu.Views.Graffles.ShowView(model: _.first(@graffles.models))
      Hospiglu.content.show(graffleView)
      shapesView = new Hospiglu.Views.Shapes.IndexView(collection: @shapes, raphael: graffleView.raphael)
      Hospiglu.shapes.show(shapesView)
      connectionsView = new Hospiglu.Views.Connections
                                    .IndexView(collection: @connections, raphael: graffleView.raphael)
      Hospiglu.connections.show(connectionsView)

    show: (id) ->
      graffle = @graffles.get(id)

      @view = new Hospiglu.Views.Graffles.ShowView(model: graffle)
      $("#graffles").html(@view.render().el)

    edit: (id) ->
      graffle = @graffles.get(id)

      @view = new Hospiglu.Views.Graffles.EditView(model: graffle)
      $("#graffles").html(@view.render().el)
