coffee = require 'coffee-script'
fs = require 'fs'
path = require 'path'
parse = require('url').parse
ext = /\.coffee$/i

module.exports = (root)->
  (req, res, next)->
    return next() if req.method != 'GET' or !ext.test req.url
    url = parse req.url
    filename = path.normalize path.join root, decodeURIComponent(url.pathname)
    return next() if !~filename.indexOf root

    fs.readFile filename, 'utf8', (err, data)->
      throw err if err
      compiled = coffee.compile data
      res.writeHead 200, 'Content-Type' : 'application/javascript'
      res.end compiled
