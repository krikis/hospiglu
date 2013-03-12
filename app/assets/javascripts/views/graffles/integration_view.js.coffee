Hospiglu.module "Views.Graffles", ->
  class @IntegrationView extends Marionette.CompositeView
    template: 'graffles/integration'

    onBeforeRender: ->
      properties = @options.graffles[0].get('properties')
      properties.noEditing = true
      @options.graffles[0].set properties: properties
      properties = @options.graffles[1].get('properties')
      properties.noEditing = true
      @options.graffles[1].set properties: properties

    onDomRefresh: ->
      # render first department graffle
      graffleView = new Hospiglu.Views.Graffles.ShowView
        model: @options.graffles[0]
        height: '45%'
        scale: 0.5
        noEditing: true
        shapesRegion: Hospiglu.firstShapes
        connectionsRegion: Hospiglu.firstConnections
      Hospiglu.firstDepartment.reset()
      Hospiglu.firstDepartment.show(graffleView)
      # render second department graffle
      graffleView = new Hospiglu.Views.Graffles.ShowView
        model: @options.graffles[1]
        height: '45%'
        scale: 0.5
        noEditing: true
        shapesRegion: Hospiglu.secondShapes
        connectionsRegion: Hospiglu.secondConnections
      Hospiglu.secondDepartment.reset()
      Hospiglu.secondDepartment.show(graffleView)
      # render your department graffle
      graffleView = new Hospiglu.Views.Graffles.ShowView
        model: @options.graffles[2]
        height: '60%'
      Hospiglu.yourDepartment.reset()
      Hospiglu.yourDepartment.show(graffleView)

    onClose: ->
      properties = @options.graffles[0].get('properties')
      delete properties.noEditing
      @options.graffles[0].set properties: properties
      properties = @options.graffles[1].get('properties')
      delete properties.noEditing
      @options.graffles[1].set properties: properties
      Hospiglu.firstDepartment.close()
      Hospiglu.secondDepartment.close()
      Hospiglu.yourDepartment.close()

