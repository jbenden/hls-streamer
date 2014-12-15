Transcoder = require '../models/transcoder'

module.exports = (app) ->
  socketIO = require('socket.io').listen(app)
  #unless app.settings.socketIO
  #  app.set 'socketIO', socketIO
  socketIO.sockets.on 'connection', (socket) ->
    console.log "CONNECTED"
    socket.on 'message', (socket) ->
      console.log socket
      if socket.substr(0,5) == "pause"
        console.log "Pausing video playback."
        myRegex = /(?:^)pause ([0-9.]+) ([a-f0-9]+)$/g
        match = myRegex.exec socket
        console.log "Pausing at position '" + match[1] + "' of '" + match[2] + "'"
      else if socket.substr(0,4) == "kill"
        console.log("kill: " + socket.substr(5))
        Transcoder.stop(socket.substr(5))
