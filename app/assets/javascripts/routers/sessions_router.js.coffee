class Hospiglu.Routers.SessionsRouter extends Backbone.Router
  initialize: (options) ->
    @sessions = new Hospiglu.Collections.SessionsCollection()
    @sessions.reset options.sessions

  routes:
    "new"      : "newSession"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newSession: ->
    @view = new Hospiglu.Views.Sessions.NewView(collection: @sessions)
    $("#sessions").html(@view.render().el)

  index: ->
    @view = new Hospiglu.Views.Sessions.IndexView(sessions: @sessions)
    $("#sessions").html(@view.render().el)

  show: (id) ->
    session = @sessions.get(id)

    @view = new Hospiglu.Views.Sessions.ShowView(model: session)
    $("#sessions").html(@view.render().el)

  edit: (id) ->
    session = @sessions.get(id)

    @view = new Hospiglu.Views.Sessions.EditView(model: session)
    $("#sessions").html(@view.render().el)
