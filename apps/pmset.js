(function() {
  var Pmset, ffi, ref;

  ref = require('ref');

  ffi = require('ffi');

  Pmset = (function() {

    function Pmset() {
      var $, a, assertionId, iokit, pm, pool, string, string2;
      $ = require('NodObjC');
      $.framework('Foundation');
      pool = $.NSAutoreleasePool('alloc')('init');
      string = $.NSString('stringWithUTF8String', 'Hello World');
      string2 = $.NSString('stringWithUTF8String', 'NoIdleSleepAssertion');
      console.log(string);
      assertionId = ref.refType(ref.types.uint32);
      a = ref.alloc(assertionId);
      iokit = ffi.Framework('/System/Library/Frameworks/IOKit.framework', {
        'IOPMAssertionCreateWithName': ['int', ['string', 'int', 'string', assertionId]],
        'IOPMAssertionRelease': ['int', ['int']]
      });
      pm = iokit.IOPMAssertionCreateWithName(string2, 255, string, a);
      iokit.IOAssertionRelease(a);
      a.deref();
      pool('drain');
    }

    return Pmset;

  })();

  module.exports = Pmset;

}).call(this);
