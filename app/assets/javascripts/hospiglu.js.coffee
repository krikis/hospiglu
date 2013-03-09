#= require_tree ./logic
#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

# Set default locale for I18n
I18n.defaultLocale = "nl"

document.ontouchmove = (event) ->
  event.preventDefault()

Backbone.Marionette.Renderer.render = (template, data) ->
  throw "Template '#{template}' not found!" unless JST[template]
  JST[template](data)

@Hospiglu = new Backbone.Marionette.Application

Hospiglu.addInitializer (options)->
  Hospiglu.addRegions
    sidebar:         '#sidebar'
    content:         '#content'
    shapes:          '#sandbox'
    connections:     '#sandbox'
    depAShapes:      '#sandbox'
    depAConnections: '#sandbox'
    depBShapes:      '#sandbox'
    depBConnections: '#sandbox'
  Hospiglu.router = new Hospiglu.Routers.BrainstormsRouter options
  Backbone.history.start
    pushState: true

