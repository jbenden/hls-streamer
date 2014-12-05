pmset = require 'pmset'
fs    = require 'fs'

transcoders = {}

class Transcoder
  @start: (req, video) ->

    args = [
      "-ss",
      "0",
      "-i",
      video.path + '/' + video.name,
      "-f",
      "mpegts",
      "-vcodec",
      "libx264",
      "-acodec",
      "libmp3lame",
      "-ar",
      "48000",
      "-ab",
      "128k",
      "-ac",
      "2",
      "-flags",
      "+loop",
      "-cmp",
      "+chroma",
      "-partitions",
      "+parti4x4+partp8x8+partb8x8",
      "-subq",
      "5",
      "-trellis",
      "1",
      "-refs",
      "1",
      "-coder",
      "0",
      "-me_range",
      "16",
      "-keyint_min",
      "25",
      "-sc_threshold",
      "40",
      "-i_qfactor",
      "0.71",
      "-b:v",
      "800k",
      "-bt",
      "200k",
      "-maxrate",
      "800k",
      "-bufsize",
      "800k",
      "-rc_eq",
      "'blurCplx^(1-qComp)'",
      "-qcomp",
      "0.6",
      "-qmin",
      "10",
      "-qmax",
      "51",
      "-qdiff",
      "4",
      "-level",
      "30",
      "-g",
      "30",
      "-async",
      "2",
      "-flags",
      "-global_header",
      "-map",
      "0",
     # https://trac.ffmpeg.org/ticket/1642
      "-f",
      "segment",
      "-segment_time",
      "10",
      #"-segment_list_size",
      #"10",
      "-segment_list"
      "#{__dirname}/../public/" + video.sha + ".m3u8"
      "-segment_list_type",
      "m3u8",
      "-segment_list_flags",
      "+live-cache",
      "-segment_format",
      "mpegts",
      "/#{__dirname}/../public/" + video.sha + ".%05d.ts"]

    #@child = transcoders[req.session.id]
    #console.log(@child)
    sha256 = video.sha
    transcoders[sha256] = require('child_process').execFile('ffmpeg', args, {detached: true, stdio: ['ignore', 1, 2]})
    transcoders[sha256].unref()
    transcoders[sha256].pmset = pmset.noIdleSleep "Transcoding video"
    transcoders[sha256].stdout.on 'data', (data) ->
      console.log(data.toString())
    transcoders[sha256].stderr.on 'data', (data) ->
      console.log(data.toString())
  @isReady: (sha256) ->
    m3u8 = "/#{__dirname}/../public/" + sha256 + ".m3u8"
    v1   = "/#{__dirname}/../public/" + sha256 + ".00000.ts"
    v2   = "/#{__dirname}/../public/" + sha256 + ".00001.ts"
    if fs.existsSync(m3u8) and fs.existsSync(v1) and fs.existsSync(v2)
      return true
    return false
  @stop: (sha256) ->
    pmset.release transcoders[sha256].pmset
    transcoders[sha256].kill()
    transcoders[sha256] = null
    delete transcoders[sha256]
  @running: (sha256) ->
    transcoders[sha256] != undefined

module.exports = Transcoder
