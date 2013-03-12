Hospiglu.module "Views.Graffles", ->
  class @VotingView extends Marionette.CompositeView
    template: 'graffles/voting'
    itemViewContainer: '.voting'
    getItemView: -> Hospiglu.Views.Graffles.VoteView


