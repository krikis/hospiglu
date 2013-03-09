Hospiglu.module 'Routers', ->
  class @BrainstormsRouter extends Backbone.Router
    initialize: (options) ->
      @options = options
      @brainstorms = new Hospiglu.Collections.BrainstormsCollection()
      @brainstorms.reset [options.brainstorm]
      @brainstorm = @brainstorms.get options.brainstorm.id
      @users = new Hospiglu.Collections.UsersCollection()
      @users.reset [options.user]
      @user = @users.get options.user.id
      @graffles = new Hospiglu.Collections.GrafflesCollection()
      @graffles.reset options.graffles
      @shapes = new Hospiglu.Collections.ShapesCollection()
      @shapes.reset options.shapes
      @connections = new Hospiglu.Collections.ConnectionsCollection()
      @connections.reset options.connections
      @noXhr = true

    routes:
      'brainstorms/first_department'  : 'firstDepartment'
      'brainstorms/second_department' : 'secondDepartment'
      'brainstorms/your_department'   : 'yourDepartment'
      'brainstorms/voting'            : 'voting'
      'brainstorms/consolidation'     : 'consolidation'
      'brainstorms.*'                 : 'currentPhase'

    firstDepartment: ->
      Hospiglu.shapesCallbacks = new Marionette.Callbacks()
      Hospiglu.connectionsCallbacks = new Marionette.Callbacks()
      if @noXhr
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
      graffle = @brainstorm.currentGraffleWith(@user)
      phases = new Hospiglu.Views.Brainstorms.PhasesView(model: @brainstorm)
      Hospiglu.sidebar.show(phases)
      graffleView = new Hospiglu.Views.Graffles.ShowView
        model: graffle
        shapes: @shapes
        connections: @connections
      Hospiglu.content.show(graffleView)

    secondDepartment: ->

    yourDepartment: ->

    voting: ->
      Hospiglu.usersCallbacks = new Marionette.Callbacks()
      Hospiglu.grafflesCallbacks = new Marionette.Callbacks()
      @brainstorm.save(state: 'closed')

    consolidation: ->

    currentPhase: ->
      @[@brainstorm.phase](arguments)