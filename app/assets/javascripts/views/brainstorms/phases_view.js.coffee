Hospiglu.module "Views.Brainstorms", ->
  class @PhasesView extends Marionette.ItemView
    template: 'brainstorms/phases'

    templateHelpers:
      humanize: (string) ->
        _.map(string.split('_'), (str) ->
          str[0].toUpperCase() + str[1..-1]
        ).join(' ') if string?

    triggers:
      'click .phase': 'noYouCant'
      'click #next_phase': 'toNextPhase'
      'click #previous_phase': 'toPreviousPhase'

    onNoYouCant: ->

    onToNextPhase: (event) ->
      nextPhase = event.model.nextPhase()
      event.model.save(phase: nextPhase)
      Backbone.history.navigate "brainstorms/#{nextPhase}", trigger: true

    onToPreviousPhase: (event) ->
      previousPhase = event.model.previousPhase()
      event.model.save(phase: previousPhase)
      Backbone.history.navigate "brainstorms/#{previousPhase}", trigger: true
