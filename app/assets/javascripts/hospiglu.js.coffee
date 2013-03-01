#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

# Set default locale for I18n
I18n.defaultLocale = "nl"

Backbone.Marionette.Renderer.render = (template, data) ->
  throw "Template '#{template}' not found!" unless JST[template]
  JST[template](data)

@Hospiglu = new Backbone.Marionette.Application

Hospiglu.addInitializer (options)->
  Hospiglu.addRegions
    sidebar:         '#sidebar'
    content:         '#content'
    menuShapes:      '#sandbox'
    menuConnections: '#sandbox'
    shapes:          '#sandbox'
    connections:     '#sandbox'
  Hospiglu.router = new Hospiglu.Routers.GrafflesRouter options
  Backbone.history.start
    pushState: true
  Backbone.history.navigate 'graffles'

