redis = require('redis').createClient()
_     = require('underscore')
fs    = require('fs')
fp    = require('filepath')
crypto= require('crypto')

class Template
  format: ->
    args = arguments
    return @str.replace /{(\d+)}/g, (match, number) ->
      return args[number]
  constructor: (str) ->
    @str = str

class Video
  # The Redis key that will store all Video objects as a hash
  @key: ->
    "Video:#{process.env.NODE_ENV}"
  # Fetch all Video objects from the filesystem
  @all: (callback) ->
    redis.hgetall Video.key(), (err, objects) ->
      videos = []
      for key, value of objects
        video = new Video JSON.parse(value)
        videos.push video
      callback null, videos
  @fromFilename: (path) ->
    st = fs.statSync(path)
    file = fp.newPath(path).basename().toString()
    path = fp.newPath(path).dirname().toString()
    shasum = crypto.createHash('sha256')
    shasum.update(path)
    sha = shasum.digest('hex')
    s = st.size.toString().commafy()
    video = new Video({sha: sha, name: file, path: path, directory: st.isDirectory(), size: s, play_count: 0, paused_at: 0, total_views: 0})
  @allFromFilesystem: (path, callback) ->
    videos = []
    files = fs.readdirSync(path)
    for idx,file of files
      continue if file[0] == '.'
      st = fs.statSync(path + "/" + file)
      s = st.size.toString().commafy()
      video = new Video({name: file, path: path, directory: st.isDirectory(), size: s, play_count: 0, paused_at: 0, total_views: 0})
      videos.push video
    callback null, videos
    @
  @getById: (id, callback) ->
    redis.hget Pie.key(), id, (err, json) ->
      if json is null
        callback new error("Video '#{id}' could not be found.")
        return
      video = new Video JSON.parse(json)
      callback null, video
  constructor: (attributes) ->
    @[key] = value for key,value of attributes
    @setDefaults()
    @
  setDefaults: ->
    @generateId()
  generateId: ->
    if not @id and @name
      @id = new Template("{0}/{1}").format(@path, @name)
  save: (callback) ->
    @generateId()
    redis.hset Video.key(), @id, JSON.stringify(@), (err, responseCode) =>
      callback null, @
  destroy: (callback) ->
    redis.hdel Video.key(), @id, (err) ->
      callback err if callback

module.exports = Video
