"use strict"
@Playlist = Backbone.Collection.extend
  currentIndex : 0
  model : Song
  currentSong : -> @at @currentIndex
  changeSong : (index)->
    song = @at index
    if song
      @currentIndex = index
      @trigger 'change:current', song
      song
    else
      false
  nextSong : ->
    @changeSong(@currentIndex + 1)
  loadJson : (json)->
    @reset JSON.parse json
