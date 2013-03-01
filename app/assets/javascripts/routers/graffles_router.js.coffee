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
      Hospiglu.shapesCallbacks = new Marionette.Callbacks()
      Hospiglu.connectionsCallbacks = new Marionette.Callbacks()
      Hospiglu.shapesCallbacks.run {}, @shapes
      Hospiglu.connectionsCallbacks.run {}, @connections
      graffleList = new Hospiglu.Views.Graffles.IndexView(collection: @graffles)
      Hospiglu.sidebar.show(graffleList)
      graffleView = new Hospiglu.Views.Graffles.ShowView
        model: _.first(@graffles.models)
        shapes: @shapes
        connections: @connections
      Hospiglu.content.show(graffleView)

    show: (id) ->  
      Hospiglu.shapesCallbacks = new Marionette.Callbacks()
      Hospiglu.connectionsCallbacks = new Marionette.Callbacks()
      @shapes = new Hospiglu.Collections.ShapesCollection()
      @shapes.fetch
        data:
          graffle_id: id
        success: (collection) ->
          Hospiglu.shapesCallbacks.run {}, collection
      @connections = new Hospiglu.Collections.ConnectionsCollection()
      @connections.fetch
        data:
          graffle_id: id
        success: (collection) ->
          Hospiglu.connectionsCallbacks.run {}, collection
      graffleList = new Hospiglu.Views.Graffles.IndexView(collection: @graffles)
      Hospiglu.sidebar.show(graffleList)
      graffleView = new Hospiglu.Views.Graffles.ShowView
        model: @graffles.get(id)
        shapes: @shapes
        connections: @connections
      Hospiglu.content.show(graffleView)


    edit: (id) ->
      graffle = @graffles.get(id)

      @view = new Hospiglu.Views.Graffles.EditView(model: graffle)
      $("#graffles").html(@view.render().el)
