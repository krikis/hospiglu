Hospiglu.Views.Connections ||= {}

class Hospiglu.Views.Connections.IndexView extends Backbone.View
  template: JST["backbone/templates/connections/index"]

  initialize: () ->
    @options.connections.bind('reset', @addAll)

  addAll: () =>
    @options.connections.each(@addOne)

  addOne: (connection) =>
    view = new Hospiglu.Views.Connections.ConnectionView({model : connection})
    @$("tbody").append(view.render().el)

  render: =>
    @$el.html(@template(connections: @options.connections.toJSON() ))
    @addAll()

    return this
