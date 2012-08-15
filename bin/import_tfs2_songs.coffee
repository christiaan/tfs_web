console.log = (d)-> process.stdout.write d + '\n'

fs = require 'fs'
path = require 'path'
mkdirp = require 'mkdirp'

getFilePath = (file)->
  file.replace process.argv[2], ''

parseDir = (dir)->
  files = fs.readdirSync dir
  files.forEach (filename)->
    if /\.txt$/i.test(filename)
      parseFile dir + '/' + filename
    else
      parseDir dir + '/' + filename

parseTag = (name, contents)->
  reg = new RegExp '<'+name+'>([\\s\\S]*)<\\/'+name+'>', 'ig'
  matches = reg.exec(contents)
  if matches and matches[1]
    matches[1].trim()
  else
    ''
translate =
  'tekst' : 'text'
  'oorsprong' : 'source'
  'toonsoort1' : 'key'
  'copyrights' : 'copyright'
  'titel' : 'title'

parseFile = (file)->
  contents = fs.readFileSync file, 'ascii'
  contents = contents.replace /\r/g, ''
  parsed = {}
  ['tekst', 'oorsprong', 'copyrights', 'toonsoort1', 'titel'].forEach (key)->
    if key == 'tekst'
      parsed[translate[key]] = parseTag(key, contents).split '\n\n'
    else
      parsed[translate[key]] = parseTag key, contents
  writeFile file, parsed

writeFile = (file, parsed)->
  filepath = path.normalize __dirname + '/../public/data/songs/' + getFilePath(file)
  dir = path.dirname filepath
  try
    stats = fs.lstatSync dir
  catch e
    mkdirp.sync dir, 0o777
  fs.writeFileSync filepath.replace(/\.txt$/i, '.json'), JSON.stringify(parsed), 'utf8'

if !process.argv[2]
  console.log 'No directory given'
else
  parseDir process.argv[2]
