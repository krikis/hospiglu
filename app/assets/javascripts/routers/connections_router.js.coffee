class Hospiglu.Routers.ConnectionsRouter extends Backbone.Router
  initialize: (options) ->
    @connections = new Hospiglu.Collections.ConnectionsCollection()
    @connections.reset options.connections

  routes:
    "new"      : "newConnection"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newConnection: ->
    @view = new Hospiglu.Views.Connections.NewView(collection: @connections)
    $("#connections").html(@view.render().el)

  index: ->
    @view = new Hospiglu.Views.Connections.IndexView(connections: @connections)
    $("#connections").html(@view.render().el)

  show: (id) ->
    connection = @connections.get(id)

    @view = new Hospiglu.Views.Connections.ShowView(model: connection)
    $("#connections").html(@view.render().el)

  edit: (id) ->
    connection = @connections.get(id)

    @view = new Hospiglu.Views.Connections.EditView(model: connection)
    $("#connections").html(@view.render().el)
