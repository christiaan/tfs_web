"use strict"
@SearchIndex = Backbone.Model.extend
  defaults :
    index : ''
    limit : 10
    socket : null,
    keyword : ''
    matches : []
  search: (keyword)->
    socket = @get 'socket'
    limit = @get 'limit'
    index = @get 'index'
    socket.emit 'search', keyword, limit, (matches)=>
      @set 'keyword' : keyword
      @set 'matches' : matches
