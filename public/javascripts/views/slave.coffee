"use strict"
@SlaveView = Backbone.View.extend
  el : 'html'
  initialize : ->
    @model.bind 'change', @render, this
    @model.bind 'destroy', @remove, this
    @model.bind 'change:bg', @setBg, this
    @model.bind 'change:text', @setText, this
    @model.bind 'change:index', @setText, this
  setBg : ()->
    bg = @model.get 'bg'
    unless bg
      @$('#bg').hide()
    else
      @$('#bg').css("background-image", 'url(' + bg + ')').show()
  setTheme : ()->
    @$('#theme').attr 'href', @model.get 'theme'
  toHtml : (text)->
    text = text.trim().split '\n'
    text.forEach (value, i)->
      if value == ''
        text[i] = '</div><div class="couplet">'
      else
        text[i] = '<div class="line">' + value + '</div>'

    text.unshift '<div class="couplet">'
    text.push '</div>'
    text.join '\n'
  setText : ()->
    html = ""
    text = @model.get 'text'
    index = @model.get 'index'
    html = @toHtml(text[index]) if text and text[index]
    @$('#text').html html
  render : ->
    @setBg()
    @setTheme()
    @setText()
    @$('#screen').zoom
      width: 1024
      height: 600
    this
