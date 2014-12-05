#= require zepto.min.js
#= require jqt.min.js
#
jQT = new $.jQT(icon: 'jqtouch.png', icon4: 'jqtouch4.png', addGlossToIcon: false, startupScreen: 'jqt_startup.png', statusBar: 'black-transparent')

class HLSStreamerApp
  constructor: (options) ->
    #if !this instanceof arguments.callee
    #  return new arguments.callee(arguments)

    @wshost      = "ws://localhost:3000/"
    @sha256      = ""
    @file        = ""
    @position    = "0"
    @isPlaying   = false
    @ws          = null
    @firstOpened = true

  WebSocketTest: ->
    @ws = io.connect @wshost
    #if window.MozWebSocket
    #  @ws = new MozWebSocket @wshost
    #else if window.WebSocket
    #  @ws = new WebSocket @wshost
      #@ws.binaryType 'blob'
    #console.log(@ws)
    #@ws.on "connect", (msg) ->
    #  alert("Websocket connected.")
    @ws.on "message", (evt) ->
      console.log("Message received: " + evt.data)
    @ws.on "close", (evt) ->
      console.log("Websocket closed. Re-opening connection.")
      @ws = io.connect @wshost
    #else
    #  alert "This platform does not support WebSockets. They are required to operate this platform."

  init: (wshost, pos, file, sha256) ->

    @wshost   = wshost
    @sha256   = sha256
    @file     = file
    @position = pos

    #@WebSocketTest()

    $(".back").on "click", ->
      @ws = io.connect @wshost
      @ws.send("kill " + self.sha256)
      jQT.goBack()

    video = $("video")
    console.log(video)
    if ! video
      return

    video.on "pause", ->
      if video[0].currentTime <= video[0].duration - 1
        #alert "Paused at position " + video[0].currentTime
        @isPlaying = false
        @ws = io.connect @wshost
        @ws.send "pause " + video[0].currentTime + " " + self.sha256
    video.on "stop", ->
      @ws = io.connect @wshost
      @ws.send("kill " + self.sha256)
    video.on "ended", ->
      if @isPlaying
        @ws = io.connect @wshost
        @ws.send("stop " + self.sha256)
        jQT.goBack()
    video.on "error", ->
      alert "Refresh the page to continue..."
    video.on "play", ->
      @isPlaying = true


$ ->
#  alert("Hello World.")
  app = new HLSStreamerApp().init(wshost, pos, file, sha256)
