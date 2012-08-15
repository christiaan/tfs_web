"use strict"
@SearchView = Backbone.View.extend
  initialize : ->
    @model.bind 'change', @render, this
  render : ->
    matches = @model.get 'matches' 
    if matches.length == 0
      $(@el).hide()
    else
      html = []
      matches.forEach (item)->
        html.push '<div>', item[2], '\t', item[3], '</div>'
      $(@el).html html.join ''
      $(@el).show()
