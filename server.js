var CoffeeScript = require('coffee-script');

/**
 * Module dependencies.
 */

var express      = require('express'),
    stylus       = require('stylus'),
    busboy       = require('express-busboy'),
    cookieParser = require('cookie-parser'),
    session      = require('express-session');

require('express-namespace')

var app = module.exports = express();

CoffeeScript.register();

var server = require('http').Server(app);
require('./apps/socket-io')(server)

// Configuration
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
busboy.extend(app);
app.use(cookieParser());
app.use(session({
  secret: "KioxIqpvdyfMXOHjVkUQmGLwEAtB0SZ9cTuNgaWFJYsbzerCDn"
}));
app.use(require('connect-assets')());
app.use(express.static(__dirname + '/public'));

if ('development' == app.get('env')) {
  //app.use(express.errorHandler({
  //  dumpExceptions: true,
  //  showStack: true
 // }));
}

app.set('port', 3001);

if ('production' == app.get('env')) {
  //app.use(express.errorHandler());
}

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

app.set('paths', ['/Volumes/Desktop', '/Volumes/Storage']);

server.listen(app.get('port'), function(){
    console.log('express listening on port ' + app.get('port'));
});
//app.listen(app.settings.port);

// advertise a http server on port #
var mdns = require('mdns');
var ad = mdns.createAdvertisement(mdns.tcp('http'), app.settings.port);
ad.start();

console.log("Express server listening on port %d in %s mode", app.settings.port, app.settings.env);
