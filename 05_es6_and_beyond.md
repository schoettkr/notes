#ES6 & Beyond
##Now & Future
- waiting for all browser without a feature supported to go away before starting to use the feature, leads to always being behind and missing out on innovations
  - transpilers and shims are important tools to keep up on the forefront of where a language is heading
###Transpiling
- tooling to transform ES6 code into equivalent (or close) matches, that work in ES5 environments
- for example shorthand property definitions:
  - ES6 Form
```js
var foo = [1,2,3];

var obj = {
    foo     // means `foo: foo`
};

obj.foo;    // [1,2,3]
```
  - transpiled Form
```js
var foo = [1,2,3];

var obj = {
    foo: foo
};

obj.foo;    // [1,2,3]
```
- transpilers perform these transformations usually in a build workflow step similar to linting,, minifation and other similar operations

###Shims/Polyfills
- not all ES6 features need a transpiler
- polyfills (aka shims) are a pattern for defining equivalent behavior from a newer environment into an older environment (when possible)
  - Syntax can not be polyfilled but APIs often can be
- for example, `Object.is(..)` is a new utility for checkig strict equality of two values but without the nuanced exception that `===` has for `NaN` and `-0` values
  - the polyfill for `Object.is(..)` pretty easy
```js
// only define this fallback if it isn't already in the browser
if (!Object.is) {
    Object.is = function(v1, v2) {
        // test for `-0`
        if (v1 === 0 && v2 === 0) {
            return 1 / v1 === 1 / v2;
        }
        // test for `NaN`
        if (v1 !== v1) {
            return v2 !== v2;
        }
        // everything else
        return v1 === v2;
    };
}
```
- [collection of ES6 Shims](https://github.com/paulmillr/es6-shim/) 

##Syntax
- some of the following features that ES6 provides are not or only partially implemented
### Block-Scoped Declarations
- the fundamental unit of variable scoping in JS has always been the `function`
  - to create a block of scope the most prevalent way to do so was (besides a regular function declaration) the immediately invoked function expression (IIFE), for example:
```js
var a = 2;

(function IIFE(){
    var a = 3;
    console.log( a );   // 3
})();

console.log( a );       // 2
```
####`let` Declarations
