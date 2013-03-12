Hospiglu.module "Views.Graffles", ->
  class @IntegrationView extends Marionette.CompositeView
    template: 'graffles/integration'

    onDomRefresh: ->
      # render first department graffle
      graffleView = new Hospiglu.Views.Graffles.ShowView
        model: @options.graffles[0]
        height: '27%'
        scale: 0.5
        noEditing: true
        shapesRegion: Hospiglu.firstShapes
        connectionsRegion: Hospiglu.firstConnections
      Hospiglu.firstDepartment.reset()
      Hospiglu.firstDepartment.show(graffleView)
      # render second department graffle
      graffleView = new Hospiglu.Views.Graffles.ShowView
        model: @options.graffles[1]
        height: '27%'
        scale: 0.5
        noEditing: true
        shapesRegion: Hospiglu.secondShapes
        connectionsRegion: Hospiglu.secondConnections
      Hospiglu.secondDepartment.reset()
      Hospiglu.secondDepartment.show(graffleView)
      # render your department graffle
      graffleView = new Hospiglu.Views.Graffles.ShowView
        model: @options.graffles[2]
        height: '62%'
      Hospiglu.yourDepartment.reset()
      Hospiglu.yourDepartment.show(graffleView)

    onClose: ->
      Hospiglu.firstDepartment.close()
      Hospiglu.secondDepartment.close()
      Hospiglu.yourDepartment.close()

