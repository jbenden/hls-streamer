Video = require '../../models/video'
fs    = require 'fs'
fp    = require 'filepath'
Transcoder = require '../../models/transcoder'

default_paths = [new Video(path:'/Volumes', name:'Storage', directory:true), new Video(path:'/Volumes', name:'Desktop', directory:true)]

routes = (app) ->
  app.get '/', (req, res) ->
    valid = false
    if req.query.q
      # if a file, then bomb out elsewhere as it is a video to play
      for path in default_paths
        p = path.path + "/" + path.name
        if p == req.query.q.substring(0,p.length)
          valid = true
      throw "Access Denied" if !valid
      st = fs.statSync(req.query.q)
      if (!st.isDirectory())
        console.log("File selected. Handle this differently.")
        video = Video.fromFilename(req.query.q)
        if !Transcoder.running(video.sha)
          Transcoder.start(req, video)
          while (!Transcoder.isReady(video.sha))
            a = 1
        res.render "#{__dirname}/views/show",
          title: "Video"
          stylesheet: 'sidewalk'
          video: video
          q: req.query.q
        return
      Video.allFromFilesystem req.query.q, (err, videos) ->
        res.render "#{__dirname}/views/index",
          title: "Videos Available"
          stylesheet: 'sidewalk'
          videos: videos
          q: req.query.q
    else
      res.render "#{__dirname}/views/index",
        title: "Videos Available"
        stylesheet: 'sidewalk'
        videos: default_paths
        q: req.query.q

module.exports = routes
