fs = require 'fs'
path = require 'path'
mkdirp = require 'mkdirp'
songPath = path.resolve __dirname + '/../public/data/songs'

parseDir = (dir)->
  files = fs.readdirSync dir
  files.forEach (filename)->
    (if /\.json$/i.test(filename) then parseFile else parseDir) dir + '/' + filename

parseFile = (file)->
  contents = fs.readFileSync file, 'utf8'
  file = file.replace songPath, ''
  song = JSON.parse contents
  text = song.text.join(' ').replace(/\W/g, '').toLowerCase()
  fs.writeSync searchIndex, 'i\t' + text + '\n' + 'p\t' + file + '|' + song.title + '\n'

dirname = path.resolve __dirname + '/../public/data/SearchIndex'
mkdirp.sync dirname, 0o777
searchIndex = fs.openSync path.join(dirname, 'index'), 'w+'
parseDir songPath
