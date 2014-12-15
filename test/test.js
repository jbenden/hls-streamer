var CoffeeScript = require('coffee-script');
CoffeeScript.register();

String.prototype.commafy = function () {
  return this.replace(/(^|[^\w.])(\d{4,})/g, function($0, $1, $2) {
    return $1 + $2.replace(/\d(?=(?:\d\d\d)+(?!\d))/g, "$&,");
  });
}
Number.prototype.commafy = function () {
  return String(this).commafy();
}
