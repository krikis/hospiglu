Hospiglu.module "Views.Graffles", ->
  class @VoteView extends Marionette.CompositeView
    template: 'graffles/vote'
    itemViewContainer: '.graffle-preview'
    getItemView: -> Hospiglu.Views.Graffles.ShowView

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

    itemViewOptions: ->
      noEditing: true
      height: '26%'
      scale: 0.5

    initialize: ->
      properties = @model.get('properties')
      properties.noEditing = true
      properties.userOnly = true
      @model.set properties: properties
      @collection = new Hospiglu.Collections.GrafflesCollection [@model]

    events:
      'click .btn': 'registerVote'

    registerVote: (event) ->
      event.preventDefault()
      event.stopPropagation()
      @$el.find('.btn-primary').removeClass('btn-primary')
      @$el.find(event.target).addClass('btn-primary')
      properties = @model.get('properties')
      properties.votes ||= {}
      properties.votes[Hospiglu.router.user.id] = parseInt $(event.target).html()
      sum = _.reduce properties.votes, ((memo, value) ->
        memo + value
      ), 0
      properties.average_vote = sum / _.values(properties.votes).length
      delete properties.noEditing
      delete properties.userOnly
      @model.save(properties: properties)
      properties.noEditing = true
      properties.userOnly = true
      @model.set(properties: properties)

    onClose: ->
      properties = @model.get('properties')
      delete properties.noEditing
      @model.set properties: properties

