"use strict"
@SongIndexesView = Backbone.View.extend
  initialize : ->
    @model.bind 'change:text', @render, this
    @model.bind 'change:index', @changeIndex, this
    @model.bind 'destroy', @remove, this
  events :
    'click [data-index]' : 'changeIndexHandler'
  changeIndexHandler: (e) ->
    @model.set {index : parseInt($(e.currentTarget).attr('data-index'), 10)}
  changeIndex : ()->
    @$('.current').removeClass 'current'
    @$('[data-index=' + @model.get('index') + ']').addClass 'current'
  toHtml : (text, index)->
    text = text.trim().split '\n'
    text.forEach (value, i)->
      if value == ''
        text[i] = '</div><div class="couplet">'
      else
        text[i] = '<div class="line">' + value + '</div>'

    classes = ['text-index couplet']
    if index == @model.get 'index'
      classes.push 'current'
    text.unshift '<div class="'+classes.join(' ')+'" data-index="'+index+'">'
    text.push '</div>'
    text.join ''
  render : ->
    html = []
    _.forEach @model.get('text'), (text, index)=>
      html.push @toHtml text, index
    $(@el).html html.join ''
    this
