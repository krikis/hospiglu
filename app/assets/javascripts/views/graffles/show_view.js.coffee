Hospiglu.module "Views.Graffles", ->
  class @ShowView extends Marionette.CompositeView
    template: 'graffles/show'

    templateHelpers:
      container: ->
        @graffle_type || "container#{@user_id}"
      humanize: (string) ->
        _.map(string.split('_'), (str) ->
          str[0].toUpperCase() + str[1..-1]
        ).join(' ') if string?

    serializeData: ->
      _.extend
        noEditing: @options.noEditing,
        @model.toJSON()

    onDomRefresh: ->
      graffleProperties = @model.get('properties')
      @paper = Raphael(@model.getContainer(), @options.width || '100%', @options.height || '62%')
      $(@paper.canvas).click (event) ->
        if event.target == @
          Hospiglu.selectedMenuItem?.remove()
          delete Hospiglu.selectedMenuItem
      shapesView = new Hospiglu.Views.Shapes.IndexView
        collection: @model.shapes()
        scale: @options.scale
        noEditing: @options.noEditing
        paper: @paper
      @shapesRegion = new Marionette.Region el: '#sandbox'
      @shapesRegion.show(shapesView)
      connectionsView = new Hospiglu.Views.Connections.IndexView
        collection: @model.connections()
        scale: @options.scale
        noEditing: @options.noEditing
        paper: @paper
      @connectionsRegion = new Marionette.Region el: '#sandbox'
      @connectionsRegion.show(connectionsView)

    onClose: ->
      @paper?.remove()
      @shapesRegion?.close()
      @connectionsRegion?.close()

