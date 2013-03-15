Hospiglu.module "Views.Graffles", ->
  class @VotingView extends Marionette.CompositeView
    template: 'graffles/voting'
    itemViewContainer: '.preview-box'
    getItemView: -> Hospiglu.Views.Graffles.ShowView

    serializeData: ->
      _.extend
        graffles: _.map(@options.graffles.models, (graffle) ->
          name: if graffle.get('user_id') is Hospiglu.router.user.id
            'Your Department'
          else
            graffle.get('properties').name
          id: graffle.id
          average: graffle.averageVote()
        ),
        @model.toJSON()

    templateHelpers:
      voteClass: (vote) ->
        if vote > 5
          'badge-success'
        else if vote < 3
          'badge-important'
        else
          'badge-info'

      userVote: ->
        @properties.votes ||= {}
        @properties.votes[Hospiglu.router.user.id]

      averageVote: ->
        if (votes = @properties.votes) and _.values(votes).length > 0
          console.log votes
          sum = _.reduce votes, ((memo, value) ->
            memo + value
          ), 0
          sum / _.values(votes).length

      roundedVote: (vote) ->
        Math.round(10 * vote) / 10

    itemViewOptions: ->
      noEditing: true
      height: '40%'
      scale: 0.75

    initialize: ->
      @model = @options.graffles.first()
      @collection = new Hospiglu.Collections.GrafflesCollection [@model]

    events:
      'click .vote': 'registerVote'
      'click .grafflesItem': 'reRender'

    modelEvents:
      'change': 'showVote'

    triggers:
      'click #consolidate': 'consolidateGraffle'

    registerVote: (event) ->
      event.preventDefault()
      event.stopPropagation()
      @$el.find('.vote').removeClass('btn-primary')
      @$el.find(event.target).addClass('btn-primary')
      properties = @model.get('properties')
      properties.votes ||= {}
      properties.votes[Hospiglu.router.user.id] = parseInt $(event.target).html()
      @model.set properties: properties
      # make sure to trigger change event
      @model.set Hospiglu.router.user.id, properties.votes[Hospiglu.router.user.id]
      @model.save()

    reRender: (event) ->
      event.preventDefault()
      event.stopPropagation()
      @model = @options.graffles.get($(event.target).attr('id'))
      Marionette.bindEntityEvents(@, @model, Marionette.getOption(@, "modelEvents"));
      @collection = new Hospiglu.Collections.GrafflesCollection [@model]
      @render()

    showVote: ->
      averageVote = @model.averageVote()
      voteBox = @$el.find(".average.#{@model.id}")
      voteBox.html(
        Math.round(10 * averageVote) / 10
      )
      voteBox.removeClass('badge-success badge-important badge-info')
      voteBox.addClass if averageVote > 5
        'badge-success'
      else if averageVote < 3
        'badge-important'
      else
        'badge-info'
      voteBox.show()
      @$el.find('.average-vote').show()

    onConsolidateGraffle: ->
      brainstorm = Hospiglu.router.brainstorm
      user = Hospiglu.router.user
      brainstorm.save(phase: 'consolidation')
      graffle = _.first brainstorm.currentGrafflesWith(user)
      @model.save(graffle_type: 'consolidation')
      graffle.save(graffle_type: null)
      Backbone.history.navigate "brainstorms/#{brainstorm.get('phase')}", trigger: true





