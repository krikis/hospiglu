Hospiglu.module "Models", ->
  class @Brainstorm extends Backbone.Model
    nextPhase: ->
      phases = @get('phases')
      nextIndex = _.indexOf(phases, @get('phase')) + 1
      phases[ Math.min(nextIndex, phases.length - 1) ]

    previousPhase: ->
      phases = @get('phases')
      previousIndex = _.indexOf(phases, @get('phase')) - 1
      phases[ Math.max(0, previousIndex) ]

    currentGrafflesWith: (user)->
      if @get('phase') == 'your_department'
        [_.first(Hospiglu.router.graffles.where(graffle_type: 'first_department')),
         _.first(Hospiglu.router.graffles.where(graffle_type: 'second_department')),
         user.yourDepartmentGraffle()]
      else if @get('phase') == 'voting'
        _.select Hospiglu.router.graffles.models, (graffle) -> graffle.get('user_id')?
      else
        Hospiglu.router.graffles.where(graffle_type: @get('phase'))

Hospiglu.module "Collections", ->
  class @BrainstormsCollection extends Backbone.Collection
    model: Hospiglu.Models.Brainstorm
    url: '/brainstorms'
