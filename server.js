var CoffeeScript = require('coffee-script');

/**
 * Module dependencies.
 */

var express = require('express'),
  stylus = require('stylus');
var busboy = require('express-busboy');
var cookieParser = require('cookie-parser');
var session = require('express-session');

require('express-namespace')

var app = module.exports = express();
CoffeeScript.register();
var server = require('http').Server(app);
require('./apps/socket-io')(server)

// Configuration
//app.configure(function () {
  app.use(stylus.middleware({
    src: __dirname + "/views",
    // It will add /stylesheets to this path.
    dest: __dirname + "/public"
  }));
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.engine('jade', require('jade').__express);
  app.set('view options', { layout: false });
  app.set('port', 3001);
  // app.use(busboy({immediate:true}));
  busboy.extend(app);
  //app.use(express.methodOverride());
  app.use(cookieParser());
  app.use(session({
    secret: "KioxIqpvdyfMXOHjVkUQmGLwEAtB0SZ9cTuNgaWFJYsbzerCDn"
  }));
  app.use(require('connect-assets')());
  // app.use(app.router);
  app.use(express.static(__dirname + '/public'));
//});

  /*
  app.use(function(req, res, next) {
      req.busboy.on('field', function(fieldname, val) {
          req.body[fieldname] = val;
      });
      req.busboy.on('finish', function() {
          next();
      });
  });
  */

//app.configure('development', function () {
  //app.use(express.errorHandler({
  //  dumpExceptions: true,
  //  showStack: true
 // }));
//});

//app.configure('test', function () {
  app.set('port', 3001);
//});

  // if ('production' == app.get('env')) {
//app.configure('production', function () {
  //app.use(express.errorHandler());
//});
  // }

String.prototype.commafy = function () {
    return this.replace(/(^|[^\w.])(\d{4,})/g, function($0, $1, $2) {
      return $1 + $2.replace(/\d(?=(?:\d\d\d)+(?!\d))/g, "$&,");
  });
}

Number.prototype.commafy = function () {
  return String(this).commafy();
}

// Global helpers
// require('./apps/helpers')(app);

// Routes
require('./apps/sidewalk/routes')(app);
//require('./apps/authentication/routes')(app);
//require('./apps/admin/routes')(app);

server.listen(app.get('port'), function(){
    console.log('express listening on port ' + app.get('port'));
});
//app.listen(app.settings.port);

// advertise a http server on port #
var mdns = require('mdns');
var ad = mdns.createAdvertisement(mdns.tcp('http'), app.settings.port);
ad.start();

console.log("Express server listening on port %d in %s mode", app.settings.port, app.settings.env);
