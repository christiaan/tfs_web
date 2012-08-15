"use strict"
@PlaylistView = Backbone.View.extend
  initialize : ->
    @collection.bind 'all', @render, this
  events :
    'click [data-index]' : 'changeIndex'
  changeIndex : (e)->
    @collection.changeSong parseInt($(e.target).attr('data-index'), 10)
  render : ->
    html = []
    @collection.each (model, index)=>
      html.push '<div class="playlist-item" data-index="', index, '">', model.get('title'), '</div>'
    @$('.contents').html(html.join '')
    this
