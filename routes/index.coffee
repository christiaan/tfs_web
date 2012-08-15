exports.index = (req, res) ->
  res.render "index",
    title: "Express"

values = {}
fs = require 'fs'
path = require 'path'
index = fs.readFileSync path.resolve(__dirname + '/../public/data/SearchIndex/index'), 'utf8'

exports.socket = (socket)->
  socket.on 'getvalue', (key, fn)->
    fn values[key]
  socket.on 'setvalue', (key, value)->
    values[key] = value
    socket.broadcast.emit key, value
  ###
  # Method to search trough the songs
  ###
  socket.on 'search', (keyword, limit, fn)->
    keyword = keyword.replace(/\W/g, '').toLowerCase()
    re = new RegExp "i\\t.*(#{keyword}).*\\np\\t(.*)\\|(.*)", 'gi'
    matches = []
    while matches.length < limit && (res = re.exec index) != null
      matches.push res
    fn matches

exports.download = (req, res, next)->
  if req.params.key of values
    res.setHeader(
      'Content-disposition'
      'attachment; filename=playlist.json'
    )
    res.setHeader 'Content-type', 'application/json'
    res.send JSON.stringify values[req.params.key]
  else
    next()
