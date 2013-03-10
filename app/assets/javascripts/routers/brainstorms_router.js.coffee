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
      if @sessionValid()
        Hospiglu.shapesCallbacks = new Marionette.Callbacks()
        Hospiglu.connectionsCallbacks = new Marionette.Callbacks()
        graffle = _.first @brainstorm.currentGrafflesWith(@user)
        if @noXhr
          @noXhr = false
          Hospiglu.shapesCallbacks.run {}, @shapes
          Hospiglu.connectionsCallbacks.run {}, @connections
        else
          @shapes = new Hospiglu.Collections.ShapesCollection()
          @shapes.fetch
            data:
              graffle_ids: [graffle.id]
            success: (collection) ->
              Hospiglu.shapesCallbacks.run {}, collection
          @connections = new Hospiglu.Collections.ConnectionsCollection()
          @connections.fetch
            data:
              graffle_ids: [graffle.id]
            success: (collection) ->
              Hospiglu.connectionsCallbacks.run {}, collection
        phases = new Hospiglu.Views.Brainstorms.PhasesView(model: @brainstorm)
        Hospiglu.sidebar.show(phases)
        graffleView = new Hospiglu.Views.Graffles.ShowView
          model: graffle
        Hospiglu.content.show(graffleView)

    secondDepartment: ->
      if @sessionValid()
        Hospiglu.shapesCallbacks = new Marionette.Callbacks()
        Hospiglu.connectionsCallbacks = new Marionette.Callbacks()
        graffle = _.first @brainstorm.currentGrafflesWith(@user)
        if @noXhr
          @noXhr = false
          Hospiglu.shapesCallbacks.run {}, @shapes
          Hospiglu.connectionsCallbacks.run {}, @connections
        else
          @shapes = new Hospiglu.Collections.ShapesCollection()
          @shapes.fetch
            data:
              graffle_ids: [graffle.id]
            success: (collection) ->
              Hospiglu.shapesCallbacks.run {}, collection
          @connections = new Hospiglu.Collections.ConnectionsCollection()
          @connections.fetch
            data:
              graffle_ids: [graffle.id]
            success: (collection) ->
              Hospiglu.connectionsCallbacks.run {}, collection
        phases = new Hospiglu.Views.Brainstorms.PhasesView(model: @brainstorm)
        Hospiglu.sidebar.show(phases)
        graffleView = new Hospiglu.Views.Graffles.ShowView
          model: graffle
        Hospiglu.content.show(graffleView)

    yourDepartment: ->
      if @sessionValid()
        Hospiglu.shapesCallbacks = new Marionette.Callbacks()
        Hospiglu.connectionsCallbacks = new Marionette.Callbacks()
        graffles = @brainstorm.currentGrafflesWith(@user)
        if @noXhr
          @noXhr = false
          Hospiglu.shapesCallbacks.run {}, @shapes
          Hospiglu.connectionsCallbacks.run {}, @connections
        else
          @shapes = new Hospiglu.Collections.ShapesCollection()
          @shapes.fetch
            data:
              graffle_ids: _.map(graffles, (graffle) -> graffle.id)
            success: (collection) ->
              Hospiglu.shapesCallbacks.run {}, collection
          @connections = new Hospiglu.Collections.ConnectionsCollection()
          @connections.fetch
            data:
              graffle_ids: _.map(graffles, (graffle) -> graffle.id)
            success: (collection) ->
              Hospiglu.connectionsCallbacks.run {}, collection
        phases = new Hospiglu.Views.Brainstorms.PhasesView(model: @brainstorm)
        Hospiglu.sidebar.show(phases)
        integrationView = new Hospiglu.Views.Graffles.IntegrationView
          graffles: graffles
        Hospiglu.content.show(integrationView)

    voting: ->
      if @sessionValid()
        Hospiglu.usersCallbacks = new Marionette.Callbacks()
        Hospiglu.grafflesCallbacks = new Marionette.Callbacks()
        @brainstorm.save(state: 'closed')

    consolidation: ->
      if @sessionValid()
        console.log 'test'

    currentPhase: ->
      Backbone.history.navigate @currentPhasePath(), trigger: true

    currentPhasePath: ->
      "brainstorms/#{@brainstorm.get('phase')}"

    sessionValid: ->
      return true if Backbone.history.fragment == @currentPhasePath()
      Backbone.history.navigate @currentPhasePath(), trigger: true
      false
