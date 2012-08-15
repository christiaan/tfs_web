"use strict"
$ ->
  slave = new SlaveView {model: new Song}
  if window.opener || window.frameElement
    window.addEventListener "message", ((message) ->
      state = message.data
      slave.model.set state
    ), false
  else
    $.getScript '/socket.io/socket.io.js', ->
      socket = io.connect('http://' + location.hostname + '/tfs')
      socket.on 'connect', ->
        socket.emit 'getvalue', 'state', (state)->
          slave.model.set state
        socket.on 'state', (state)->
          slave.model.set state
