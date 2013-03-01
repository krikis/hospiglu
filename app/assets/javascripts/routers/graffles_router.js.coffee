Hospiglu.module "Routers", ->
  class @GrafflesRouter extends Backbone.Router
    initialize: (options) ->
      @graffles = new Hospiglu.Collections.GrafflesCollection()
      @graffles.reset options.graffles
      Hospiglu.shapesCallbacks = new Marionette.Callbacks()
      @shapes = new Hospiglu.Collections.ShapesCollection()
      unless _.isEmpty options.shapes
        @shapes.reset options.shapes
        Hospiglu.shapesCallbacks.run {}, @shapes
      Hospiglu.connectionsCallbacks = new Marionette.Callbacks()
      @connections = new Hospiglu.Collections.ConnectionsCollection()
      unless _.isEmpty options.connections
        @connections.reset options.connections
        Hospiglu.connectionsCallbacks.run {}, @connections

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
      graffleList = new Hospiglu.Views.Graffles.IndexView(collection: @graffles)
      Hospiglu.sidebar.show(graffleList)
      graffleView = new Hospiglu.Views.Graffles.ShowView(model: @graffles.get(id))
      Hospiglu.content.show(graffleView)
      Hospiglu.shapesCallbacks = new Marionette.Callbacks()
      Hospiglu.connectionsCallbacks = new Marionette.Callbacks()
      @shapes = new Hospiglu.Collections.ShapesCollection()
      @connections = new Hospiglu.Collections.ConnectionsCollection()
      @shapes.fetch
        data:
          graffle_id: id
        success: (collection) ->
          Hospiglu.shapesCallbacks.run {}, collection
      shapesView = new Hospiglu.Views.Shapes.IndexView(collection: @shapes, raphael: graffleView.raphael)
      Hospiglu.shapes.show(shapesView)
      @connections.fetch
        data:
          graffle_id: id
        success: (collection) ->
          Hospiglu.connectionsCallbacks.run {}, collection
      connectionsView = new Hospiglu.Views.Connections
                                    .IndexView(collection: @connections, raphael: graffleView.raphael)
      Hospiglu.connections.show(connectionsView)

    edit: (id) ->
      graffle = @graffles.get(id)

      @view = new Hospiglu.Views.Graffles.EditView(model: graffle)
      $("#graffles").html(@view.render().el)
