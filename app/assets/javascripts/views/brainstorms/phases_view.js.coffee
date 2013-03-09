Hospiglu.module "Views.Brainstorms", ->
  class @PhasesView extends Marionette.ItemView
    template: 'brainstorms/phases'

    triggers:
      'click .first_department': 'show:firstDepartment'
      'click .second_department': 'show:secondDepartment'

    onShowFirstDepartment: ->
      Backbone.history.navigate "brainstorms/first_department", trigger: true

    onShowSecondDepartment: ->
      Backbone.history.navigate "brainstorms/second_department", trigger: true