# Victorica [![NPM version][npm-image]][npm] [![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]

[![Sauce Test Status][sauce-image]][sauce]

> a simple html beautifier

[DEMO](http://jsrun.it/59naga/victorica)

## Installation
### Via npm

```bash
$ npm install victorica --save
```

```js
var victorica= require('victorica');
console.log(victorica); //object
```

### Via bower

```bash
$ bower install victorica --save
```

```html
<script src="bower_components/victorica/victorica.min.js"></script>
<script>
  console.log(victorica); //object
</script>
```

### Via rawgit.com(the simple way)

```html
<script src="https://cdn.rawgit.com/59naga/victorica/master/victorica.min.js"></script>
<script>
  console.log(victorica); //object
</script>
```

# API

## .beautify(html,options) -> beautified

Adjust the indentation using `options.space` (default `  `).

```html
<!DOCTYPE html><html>
<head><meta charset="UTF-8" />
<title>index.html</title><script>
  console.log("<dont touch this>");
</script><style>/*ignore me*/</style></head>
<body><pre>foo bar baz</pre><div>
  <span><strong>Lorem</strong> <em>ipsum</em> dolor sit amet.</span>
  <pre>  dont touch
  this.  </pre>
</div><!--this
 is
  comment -->
</body>
</html>
```

```js
// Dependencies
var fs= require('fs');
var html= fs.readFileSync('index.html','utf8');

// Defaults
var options= {
  // indentation character
  space: '  ',

  // doesn't handle the innerHTML of matching elements
  ignore: ['script','style','title','a','abbr','acronym','b','bdo','big','button','cite','code','dfn','em','i','img','kbd','label','map','object','pre','q','samp','small','span','strong','sub','sup','textarea','tt','var'],

  // if true, remove self closing char (e.g <img /> -> <img>)
  removeSelfClose: true,
};

console.log(victorica.beautify(html,options));
// <!DOCTYPE html>
// <html>
//   <head>
//     <meta charset="UTF-8">
//     <title>index.html</title>
//     <script>
//   console.log("<dont touch this>");
// </script>
//     <style>/*ignore me*/</style>
//   </head>
//   <body>
//     <pre>foo bar baz</pre>
//     <div>
//       <span><strong>Lorem</strong> <em>ipsum</em> dolor sit amet.</span>
//       <pre>  dont touch
//   this.  </pre>
//     </div>
//     <!--this
//  is
//   comment -->
//   </body>
// </html>
```

License
---
[MIT][License]

[License]: http://59naga.mit-license.org/

[sauce-image]: http://soysauce.berabou.me/u/59798/victorica.svg
[sauce]: https://saucelabs.com/u/59798
[npm-image]:https://img.shields.io/npm/v/victorica.svg?style=flat-square
[npm]: https://npmjs.org/package/victorica
[travis-image]: http://img.shields.io/travis/59naga/victorica.svg?style=flat-square
[travis]: https://travis-ci.org/59naga/victorica
[coveralls-image]: http://img.shields.io/coveralls/59naga/victorica.svg?style=flat-square
[coveralls]: https://coveralls.io/r/59naga/victorica?branch=master
