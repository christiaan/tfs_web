class @Slaves
  constructor: (@slaves = [])->
  push: (win)-> @slaves.push win
  send: (data)->
    @slaves = _.filter @slaves, (win)->
      if !win.closed
        win.postMessage data, '*'
        true
      else
        false
