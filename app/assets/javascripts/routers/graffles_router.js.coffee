Hospiglu.module "Routers", ->
  class @GrafflesRouter extends Backbone.Router
    initialize: (options) ->
      @options = options
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
      graffle = _.first(@graffles.models)
      graffleList = new Hospiglu.Views.Graffles.IndexView(collection: @graffles, current: graffle.id)
      Hospiglu.sidebar.show(graffleList)
      if graffle
        graffleView = new Hospiglu.Views.Graffles.ShowView
          model: graffle
          shapes: @shapes
          connections: @connections
        Hospiglu.content.show(graffleView)

    show: (id) ->
      if graffle = @graffles.get(id) || @graffles.get(@options.graffle_id) || _.first(@graffles.models)
        Hospiglu.shapesCallbacks = new Marionette.Callbacks()
        Hospiglu.connectionsCallbacks = new Marionette.Callbacks()
        if graffle.id == @options.graffle_id
          delete @options.graffle_id
          Hospiglu.shapesCallbacks.run {}, @shapes
          Hospiglu.connectionsCallbacks.run {}, @connections
        else
          @shapes = new Hospiglu.Collections.ShapesCollection()
          @shapes.fetch
            data:
              graffle_id: graffle.id
            success: (collection) ->
              Hospiglu.shapesCallbacks.run {}, collection
          @connections = new Hospiglu.Collections.ConnectionsCollection()
          @connections.fetch
            data:
              graffle_id: graffle.id
            success: (collection) ->
              Hospiglu.connectionsCallbacks.run {}, collection
        graffleList = new Hospiglu.Views.Graffles.IndexView(collection: @graffles, current: graffle.id)
        Hospiglu.sidebar.show(graffleList)
        graffleView = new Hospiglu.Views.Graffles.ShowView
          model: graffle
          shapes: @shapes
          connections: @connections
        Hospiglu.content.show(graffleView)


    edit: (id) ->
      graffle = @graffles.get(id)

      @view = new Hospiglu.Views.Graffles.EditView(model: graffle)
      $("#graffles").html(@view.render().el)
