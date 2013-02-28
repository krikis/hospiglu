Hospiglu.module "Views.Graffles", ->
  class @GraffleView extends Marionette.ItemView
    tagName: 'tr'
    template: 'graffles/graffle'
