Hospiglu.module "Models", ->
  class @Brainstorm extends Backbone.Model
    nextPhase: ->
      currentIndex = _.indexOf(@get(phases), @get('phase'))
      phases[ if currentIndex >= 0 then currentIndex else 0 ]

    currentGraffleWith: (user)->
      if @get('phase') == 'your_department'
        user.yourDepartmentGraffle()
      else
        _.first Hospiglu.router.graffles.where(graffle_type: @get('phase'))

Hospiglu.module "Collections", ->
  class @BrainstormsCollection extends Backbone.Collection
    model: Hospiglu.Models.Brainstorm
    url: '/brainstorms'
