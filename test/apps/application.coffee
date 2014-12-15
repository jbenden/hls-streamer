chai   = require('chai')
expect = chai.expect
request= require('supertest')
express= require('express')
stylus = require('stylus')

app = express()
app.use(stylus.middleware({
  src: __dirname + "/views",
  dest: __dirname + "/public"
}));
app.set('views', __dirname + '/views');
app.set('view engine', 'jade');
app.engine('jade', require('jade').__express);
app.set('view options', { layout: false });
app.use(require('connect-assets')());
routes = require('../../apps/sidewalk/routes')(app)

describe "Routes", ->
    describe "GET root", ->
        it "should respond", ->
            request(app).get('/')
              .send()
              .expect('Content-Type', /html/)
              .expect(200)
              .end (err, res) ->
                if err
                    throw err
                expect(res.charset).to.contain('utf-8')
                expect(res.text).has.contain('toolbar')
                expect(res.text).has.contain('?q=/Volumes/Storage')

