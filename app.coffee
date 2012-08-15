require "coffee-script"
express = require "express"
io = require "socket.io"
coffeeConnect = require "./coffee-connect"
routes = require "./routes"

app = module.exports = express.createServer()
app.configure ->
  app.set "views", __dirname + "/views"
  app.set "view engine", "ejs"
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use coffeeConnect __dirname + "/public"
  app.use express.static __dirname + "/public"
  app.use express.favicon __dirname + "/public/images/favicon.ico"

app.configure "development", ->
  app.use express.errorHandler
    dumpExceptions: true
    showStack: true

app.configure "production", ->
  app.use express.errorHandler()

app.get "/", routes.index
app.get "/download/:key", routes.download
io = io.listen app
io.configure ->
  io.set 'transports', ['websocket', 'flashsocket', 'xhr-polling']
io.of('/tfs').on "connection", routes.socket

