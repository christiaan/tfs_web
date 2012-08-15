"use strict"
@MasterView = Backbone.View.extend
  slaveUrl : '/slave.html'
  ###
  # Initializes the Masterview
  # options = { el, search, socket }
  ###
  initialize : ->
    @search = @options.search
    @searchView = new SearchView {el: @$('#searchresults'), model : @search}
    @setSocket @options.socket
    @playlist = new Playlist
    @playlist.bind 'change:current', @stagePlaylistItem, this
    @playlist.bind 'reset', =>
      @socket.emit 'setvalue', 'playlist', @playlist.toJSON()
    @playlistView = new PlaylistView {el: @$('#playlist'), collection: @playlist}
    @stage = new Song
    @stage.bind 'change', @stageChanged, this
    @stageView = new SongIndexesView {model: @stage}
    @stageSlaves = new Slaves
    @live = new Song
    @live.bind 'change', @liveChanged, this
    @liveView = new SongIndexesView {model: @live}
    @liveSlaves = new Slaves
  events :
    'click #playlist [data-action=playlist-open]' : 'openPlaylist'
    'change #playlist-upload' : 'changePlaylist'
    'keyup #command' : 'commandHandler'
    'click #logo' : 'openPopupScreen'
    'click [data-action=stage-revert]' : 'revertStage'
    'click [data-action=stage-commit]' : 'commitStage'
    'dblclick #stage [data-index]' : 'commitStage'
  setSocket : (socket)->
    @socket = socket
    @socket.on 'connect', =>
      @socket.emit 'getValue', 'staging', (state)=>
        @stage.set state
      @socket.on 'staging', (state)=>
        if !_.isEqual @stage.toJSON(), state
          @stage.set state

      @socket.emit 'getvalue', 'state', (state)=>
        @live.set state
      @socket.on 'state', (state)=>
        if !_.isEqual @live.toJSON(), state
          @live.set state

      @socket.emit 'getvalue', 'playlist', (playlist)=>
        @playlist.reset playlist
      @socket.on 'playlist', (playlist)=>
        if !_.isEqual @playlist.toJSON(), playlist
          @playlist.reset playlist
  openPlaylist : ->
    @$('#playlist-upload').trigger 'click'
  changePlaylist : (e)->
    if e.target.files && e.target.files[0]
      file = e.target.files[0]
      reader = new FileReader
      reader.onload = (e)=>
        @playlist.loadJson e.target.result
      reader.readAsText file
  commandHandler : (e)->
    command = $(e.target).val()
    # on ESC clear the field
    if e.which is 27
      $(e.target).val ''
    # / inits a search query
    else if command.substring(0, 1) is '/'
      keyword = command.substring 1
      @search.search keyword if keyword
  stageChanged : ->
    @socket.emit 'setvalue', 'staging', @stage.toJSON()
    @stageSlaves.send @stage.toJSON()
  liveChanged : ->
    @socket.emit 'setvalue', 'state', @live.toJSON()
    @liveSlaves.send @live.toJSON()
  openPopupScreen : (e)->
    win = window.open(@slaveUrl, 'client', 'width=200,height=200')
    @liveSlaves.push win
    # kill the popup when the master reloads
    $(window).bind 'beforeunload', -> if !win.closed then win.close()
  revertStage: (e)->
    @stagePlaylistItem @playlist.currentSong()
  commitStage: (e)->
    if @stage
      @live.set @stage.toJSON()
      song = @playlist.nextSong()
      if song then @stagePlaylistItem song
  stagePlaylistItem: (song)->
    if song then @stage.set song.toJSON()
  render : ->
    @playlistView.render()
    @$('#stage .indexes').append @stageView.render().el
    @$('#live .indexes').append @liveView.render().el
    @$('#stage iframe').attr('src', @slaveUrl).load =>
      @stageSlaves.push document.getElementById('staging_iframe').contentWindow
    @$('#live iframe').attr('src', @slaveUrl).load =>
      @liveSlaves.push document.getElementById('live_iframe').contentWindow
    this

