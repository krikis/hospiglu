Hospiglu.module "Views.Graffles", ->
  class @GraffleView extends Marionette.ItemView
    template: 'graffles/graffle'

    triggers:
      'click .show_graffle': 'show:graffle'

    onShowGraffle: (args)->
      Backbone.history.navigate "graffles/#{args.model.get('id')}", trigger: true
