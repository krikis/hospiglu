Hospiglu.module "Views.Graffles", ->
  class @VotingView extends Marionette.CompositeView
    template: 'graffles/voting'
    itemViewContainer: '.graffle-preview'
    getItemView: -> Hospiglu.Views.Graffles.ShowView

    serializeData: ->
      _.extend
        graffles: _.map(@options.graffles.models, (graffle) ->
          name: graffle.get('properties').name
          id: graffle.id
        ),
        @model.toJSON()

    templateHelpers:
      voteClass: ->
        if @properties.average_vote > 5
          'badge-success'
        else if @properties.average_vote < 3
          'badge-important'
        else
          'badge-info'

      userVote: ->
        @properties.votes ||= {}
        @properties.votes[Hospiglu.router.user.id]

      averageVote: ->
        Math.round(10 * @properties.average_vote) / 10

    itemViewOptions: ->
      noEditing: true
      height: '40%'
      scale: 0.75

    initialize: ->
      @model = @options.graffles.first()
      @collection = new Hospiglu.Collections.GrafflesCollection [@model]

    events:
      'click .vote': 'registerVote'

    modelEvents:
      'change': 'showVote'

    registerVote: (event) ->
      event.preventDefault()
      event.stopPropagation()
      @$el.find('.vote').removeClass('btn-primary')
      @$el.find(event.target).addClass('btn-primary')
      properties = @model.get('properties')
      properties.votes ||= {}
      properties.votes[Hospiglu.router.user.id] = parseInt $(event.target).html()
      sum = _.reduce properties.votes, ((memo, value) ->
        memo + value
      ), 0
      properties.average_vote = sum / _.values(properties.votes).length
      @model.set properties: properties
      # make sure to trigger change event
      @model.set Hospiglu.router.user.id, properties.votes[Hospiglu.router.user.id]
      @model.save()

    showVote: ->
      @$el.find('.average-vote .badge').html(
        Math.round(10 * @model.get('properties').average_vote) / 10
      )


