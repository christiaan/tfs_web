$ ->
  $.get '/data/SearchIndex/index', (index)->
    socket = io.connect('http://' + location.hostname + '/tfs')
    master = new MasterView
      el: $ 'body'
      socket: socket
      search: new SearchIndex
        index : index
        limit : 100
        socket : socket

    master.render()
    # app.openPopupScreen()
