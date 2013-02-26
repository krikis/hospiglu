#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

# Set default locale for I18n
I18n.defaultLocale = "nl"

Backbone.Marionette.Renderer.render = (template, data) ->
  if !JST[template]
    throw "Template '" + template + "' not found!"
  JST[template](data)

@Hospiglu = new Backbone.Marionette.Application
