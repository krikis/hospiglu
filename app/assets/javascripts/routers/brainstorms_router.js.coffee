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
        Raphael.getColor.reset()
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
        Hospiglu.navigation.show(phases)
        graffleView = new Hospiglu.Views.Graffles.ShowView
          model: graffle
        Hospiglu.content.show(graffleView)

    secondDepartment: ->
      if @sessionValid()
        Raphael.getColor.reset()
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
        Hospiglu.navigation.show(phases)
        graffleView = new Hospiglu.Views.Graffles.ShowView
          model: graffle
        Hospiglu.content.show(graffleView)

    yourDepartment: ->
      if @sessionValid()
        Raphael.getColor.reset()
        Hospiglu.shapesCallbacks = new Marionette.Callbacks()
        Hospiglu.connectionsCallbacks = new Marionette.Callbacks()
        @brainstorm.save(state: 'open')
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
        Hospiglu.navigation.show(phases)
        integrationView = new Hospiglu.Views.Graffles.IntegrationView
          graffles: graffles
        Hospiglu.content.show(integrationView)

    voting: ->
      if @sessionValid()
        Raphael.getColor.reset()
        Hospiglu.grafflesCallbacks = new Marionette.Callbacks()
        Hospiglu.shapesCallbacks = new Marionette.Callbacks()
        Hospiglu.connectionsCallbacks = new Marionette.Callbacks()
        @brainstorm.save(state: 'closed')
        if @noXhr
          @noXhr = false
          Hospiglu.grafflesCallbacks.run {}, @graffles
          Hospiglu.shapesCallbacks.run {}, @shapes
          Hospiglu.connectionsCallbacks.run {}, @connections
        else
          @graffles.fetch
            data:
              brainstorm_id: @brainstorm.id
            success: (collection) ->
              Hospiglu.grafflesCallbacks.run {}, collection
          @shapes = new Hospiglu.Collections.ShapesCollection()
          @shapes.fetch
            data:
              brainstorm_id: @brainstorm.id
            success: (collection) ->
              Hospiglu.shapesCallbacks.run {}, collection
          @connections = new Hospiglu.Collections.ConnectionsCollection()
          @connections.fetch
            data:
              brainstorm_id: @brainstorm.id
            success: (collection) ->
              Hospiglu.connectionsCallbacks.run {}, collection
        phases = new Hospiglu.Views.Brainstorms.PhasesView(model: @brainstorm)
        Hospiglu.navigation.show(phases)
        Hospiglu.grafflesCallbacks.add =>
          graffles = new Hospiglu.Collections.GrafflesCollection @brainstorm.currentGrafflesWith(@user)
          votingView = new Hospiglu.Views.Graffles.VotingView
            graffles: graffles
          Hospiglu.content.show(votingView)

    consolidation: ->
      if @sessionValid()
        Raphael.getColor.reset()
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
        Hospiglu.navigation.show(phases)
        graffleView = new Hospiglu.Views.Graffles.ShowView
          model: graffle
        Hospiglu.content.show(graffleView)

    currentPhase: ->
      Backbone.history.navigate @currentPhasePath(), trigger: true

    currentPhasePath: ->
      "brainstorms/#{@brainstorm.get('phase')}"

    sessionValid: ->
      return true if Backbone.history.fragment == @currentPhasePath()
      Backbone.history.navigate @currentPhasePath(), trigger: true
      false
