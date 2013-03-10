Hospiglu.module "Views.Graffles", ->
  class @IntegrationView extends Marionette.CompositeView
    template: 'graffles/integration'
    onDomRefresh: ->
      graffle = _.last @options.graffles
      graffleView = new Hospiglu.Views.Graffles.ShowView
        model: graffle
      Hospiglu.content.show(graffleView)