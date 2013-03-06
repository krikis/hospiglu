Hospiglu.module "Views.Graffles", ->
  class @GraffleView extends Marionette.ItemView
    template: 'graffles/graffle'
    tagName: 'li'
    attributes: ->
      class: ('active' if @model.id == @options.current)

    triggers:
      'click .show_graffle': 'show:graffle'

    onShowGraffle: (args)->
      Backbone.history.navigate "graffles/#{args.model.get('id')}", trigger: true
