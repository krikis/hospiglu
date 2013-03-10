Hospiglu.module "Views.Graffles", ->
  class @ShowView extends Marionette.CompositeView
    template: 'graffles/show'

    templateHelpers:
      container: ->
        @graffle_type || "container#{@user_id}"

    onDomRefresh: ->
      graffleProperties = @model.get('properties')
      @paper = Raphael(@model.getContainer(), @options.width || '100%', @options.height || '90%')
      $(@paper.canvas).click (event) ->
        if event.target == @
          Hospiglu.selectedMenuItem?.remove()
          delete Hospiglu.selectedMenuItem
      shapesView = new Hospiglu.Views.Shapes.IndexView
        collection: @model.shapes()
        scale: @options.scale
        noEditing: @options.noEditing
        paper: @paper
      (@options.shapesRegion || Hospiglu.shapes).show(shapesView)
      connectionsView = new Hospiglu.Views.Connections.IndexView
        collection: @model.connections()
        scale: @options.scale
        noEditing: @options.noEditing
        paper: @paper
      (@options.connectionsRegion || Hospiglu.connections).show(connectionsView)

    onClose: ->
      @paper?.remove()
