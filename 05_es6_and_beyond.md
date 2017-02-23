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
- using `let` creates declarations that are bound to any block (block scoping)
  - a pair of `{ .. }` and using `let` in that block creates a scope
```js
var a = 2;
{
  let a = 3;
  console.log(a); // 3
}
console.log(a); // 2
```
- it's recommended to put the `let` declarations at the very top of that block to make it clear that this block is only for the purpose of declaring scope for those variables
```js
{ let a = 2, b, c;
  // ...
}
```
- accessing a `let`-declared variable earlier that its `let ..` declaration/initialization causes an error, whereas with `var` declarations the ordering does'nt matter
  - `var`/`function` declarations are intialised with `undefined` ==> `undefined`
  - `let`/`const`/`class` stay **uninitialised** ==> `ReferenceError`
```js
{
  console.log( a );   // undefined
  console.log( b );   // ReferenceError!

  var a;
  let b;
}
```
#####`let` + `for`
- an `let i` in a `for` header declares an `i` not just for the `for` loop itself, but it declares a new `i` for each iteration of the loops
  - that means that closures created inside the loop iteration close over those per-iteration variables as expected
```js
var funcs = [];
for (let i = 0; i < 5; i++) {
    funcs.push( function(){
        console.log( i );
    } );
}
funcs[3]();     // 3
```
  - the same snippet with `var i` in the for loop header, would result in getting `5` instead of `3`
    - because there'd only be one `i` in the outer scope that was closed over, instead of a new `i` for each iteration's function to close over

#####Block-scoped Functions
- function declarations inside of a block are now scoped to that block
```js
{
    foo();                  // works!

    function foo() {
        // ..
    }
}
foo();                      // ReferenceError
```
- the function declaration is scoped to the wrapping block
  - it is also hoisted within the block (no TDZ error trap)

###Spread/Rest
- the new `...` operator is referred to as the *spread* or *rest* operator depending on how it's used
```js
function foo(x,y,z) {
    console.log( x, y, z );
}

foo( ...[1,2,3] );              // 1 2 3
```
- when `...` is used in front of an iterable (e.g array) it acts to "spread" it out into its individual values
- it's typically used to spread out an array as a set of arguments to a function call
- can also be used in other contexts, such as inside another array declaration
```js
var a = [2,3,4];
var b = [ 1, ...a, 5 ];

console.log( b );                   // [1,2,3,4,5]
```

- the other common usage of `...` can be seen as the opposite to *gather* a set of values together into an array
```js
function foo(x, y, ...z) {
    console.log( x, y, z );
}

foo( 1, 2, 3, 4, 5 );           // 1 2 [3,4,5]
```
- `...z` says "gather the ***rest*** of the arguments into an array called `z`"
  - because `x` was assigned 1 and `y` was assigned 2, the rest of the arguments(3,4,5) where gathered into `z`
- if there aren't any parameters `...` gathers all arguments
  - this creates a real array, which might be useful to iterate over the arguments or w/e

###Default Parameter Values
- ES6 introduces helpful syntax to streamline the assignment of default values to missing arguments
```js
function foo(x = 11, y = 31) {
    console.log( x + y );
}

foo();                  // 42
foo( 5, 6 );            // 11
foo( 0, 42 );           // 42

foo( 5 );               // 36
foo( 5, undefined );    // 36 <-- `undefined` is missing
foo( 5, null );         // 5  <-- null coerces to `0`

foo( undefined, 6 );    // 17 <-- `undefined` is missing
foo( null, 6 );         // 6  <-- null coerces to `0`
```
- `x = 11` in a function declaration is more like `x !== undefined ? x : 11` than the much more common idiom `x || 11`

####Default Value Expressions
- Functions default values can be more than just simple values like `31`, they can be any valid expression, even a function call
```js
function bar(val) {
    console.log( "bar called!" );
    return y + val;
}

function foo(x = y + 3, z = bar( x )) {
    console.log( x, z );
}

var y = 5;
foo();                              // "bar called"
                                    // 8 13
foo( 10 );                          // "bar called"
                                    // 10 15
y = 6;
foo( undefined, 10 );               // 9 10 bar doesnt run
```
- a default value expression can even be an inline function expression call (IIFE)
```js
function foo( x =
    (function(v){ return v + 11; })( 31 )
) {
    console.log( x );
}

foo();          // 42
```

###Destructuring
- a structured assignment is for example
```js
function foo() {
    return [1,2,3];
}

var tmp = foo(),
    a = tmp[0], b = tmp[1], c = tmp[2];

console.log( a, b, c );             // 1 2 3
```
or with objects:
```js
function bar() {
    return {
        x: 4,
        y: 5,
    };
}
var tmp = bar(),
    x   = tmp.x, y = tmp.y;
console.log( x, y);             // 4 5 
```
- this manual assignment always requires a temporal variable
- ES6 eliminates this need with a dedicated syntax for *destructuring*
```js
var [ a, b, c ] = foo();
var { x: x, y: y, z: z } = bar();

console.log( a, b, c );             // 1 2 3
console.log( x, y, z );             // 4 5 6
```
####Object Property Assignment Pattern
- if the property name being matched is the same as the variable, the syntax can be shortened
```js
var { x, y, z } = bar();
console.log( x, y, z );             // 4 5 6
```
- but is `{ x, ..}` leaving off the `x:` part or leaving off the `: x` part?
  - it leaves off the `x:` part
- the longer form allows to assign a property to a different variable name
```js
var { x: bam, y: baz, z: bap } = bar();
console.log( bam, baz, bap );       // 4 5 6
console.log( x, y, z );             // ReferenceError
```
- the way this assignment works is like in a object literal but actually flipped around
  - in `var obj = { a: xy, b: yx }` `a` & `b` are the targets and `xy` and `yx` are the sources (target <-- source)
  - the object destructuring assignment inverts this `target: source` pattern
    - in `var { x: bam, y: baz, z: bap } = bar();` `bam` is the target value that is assigned to (source --> target)
- if the variables are already declared, then the destructuring only does assignments
- it can even solve the traditional "swap to variables" task without a temporary variable
```js
var x = 10, y = 20;
[ y, x ] = [ x, y ];
console.log( x, y );                // 20 10
```
 
####Repeated Assignments
