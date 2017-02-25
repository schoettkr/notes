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
- the object destructuring form allows a source property to be listet multiple times
```js
var { a: X, a: Y } = { a: 1 };
X;  // 1
Y;  // 1
```
####Too Many, Too Few, Just Enough
- [see](https://github.com/getify/You-Dont-Know-JS/blob/master/es6%20%26%20beyond/ch2.md#too-many-too-few-just-enough)

####Default Value Assignment
- destructuring too offers a default value option for an assignment using `=`
```js
var [ a = 3, b = 6, c = 9, d = 12 ] = foo();
var { x = 5, y = 10, z = 15, w = 20 } = bar();
console.log( a, b, c, d );          // 1 2 3 12
console.log( x, y, z, w );          // 4 5 6 20
```

###Object Literal Extensions
####Concise Properties
- to define a property that has the same as a lexical identifier (e.g variable) it can be shortened from `x: x` to `x`
```js
var x = 2, y = 3,
    o = {
        x,
        y
    };
```
####Concise Methods
- functions attached to properties in object literals also have a concise Form
```js
var o = {
    x() {   // instead of x: function() { .. }
        // ..
    },
    y() {
        // ..
    }
}
```
- concise methods also have special behaviors that the old counterparts dont, e.g the allowance for `super`
- concise methods are a nice convenience but should only be used if they're not needed to do recursion or event binding/unbinding

####ES5 Getter/Setter
```js
var o = {
    __id: 10,
    get id() { return this.__id++; },
    set id(v) { this.__id = v; }
}

o.id;           // 10
o.id;           // 11
o.id = 20;
o.id;           // 20

// and:
o.__id;         // 21
o.__id;         // 21 -- still!
```
####Computed Property Names
- ES6 allows specifying an expression directly in the object literal that should be computed, whose result is the property name assigning
  - any valid expression can appear inside the `[ ... ]`
```js
var prefix = "user_";

var o = {
    baz: function(..){ .. },
    [ prefix + "foo" ]: function(..){ .. },
    [ prefix + "bar" ]: function(..){ .. }
    ..
};
```
####Setting `[[Prototype]]`
- setting the `__proto__` property name in the object literal is standardized as of ES6
```js
var o1 = {
    // ..
};
var o2 = {
    __proto__: o1
};
```
- to set the Prototype of an existing object ES6 provides `Object.setPrototypeOf(*obj*, *prototype*)`

####Object `super`
- `super` is only allowed for concise methods, not regular function expression properties
```js
var o1 = {
    foo() {
        console.log( "o1:foo" );
    }
};
var o2 = {
    foo() {
        super.foo();
        console.log( "o2:foo" );
    }
};

Object.setPrototypeOf( o2, o1 );
o2.foo();       // o1:foo
                // o2:foo
```

###Temple Literals
- alternative name: *interpolated string literals* (or interpoliterals)
- JS already allows declaring string literals with `"` and `'`
- ES6 introduces a new type of string literal using the ``` backtick as the delimiter
  - these string literals allow basic string interpolation expressions to be embedded, which are then automatically parsed & evaluated
```js
var name = "Kyle";

var greeting = `Hello ${name}!`;

console.log( greeting );            // "Hello Kyle!"
console.log( typeof greeting );     // "string"
```
- ``..`` around a series of chars to interpret them as a string literal
- any expression of the form `${..}` are parsed and evaluated inline immediately
  - this string literal is more like an IIFE in the sense that it's automatically evaluated inline
- this parsing and evaluating is usually called *interpolation*

####Interpolated Expressions
- any valid expression is allowed inside a interpolated string literal, including function calls, inline function expression calls and even other interpolated string literals
  - an interpolated string literal is just lexically scoped where it appears
```js
function upper(s) {
    return s.toUpperCase();
}

var who = "reader";

var text =
`A very ${upper( "warm" )} welcome
to all of you ${upper( `${who}s` )}!`;

console.log( text );
// A very WARM welcome
// to all of you READERS!
```
####Tagged Template Literals
- alternative name: *tagged string literals* 
- [see](https://github.com/getify/You-Dont-Know-JS/blob/master/es6%20%26%20beyond/ch2.md#tagged-template-literals)

###Arrow Functions
- comparison between normal functions and arrow Functions
```js
function foo(x,y) {
    return x + y;
}

// versus

var foo = (x,y) => x + y;
```
- the arrow function is just the `(x,y) => x + y` part and that function reference is just assigned to `foo`
- the body of an arrow function only needs to be enclosed by `{ .. }` if there's more than on expression or if the body consists of a non-expression statement
- arrow functions are always function expressions, there is no arrow function declaration
  - they're anonymous functions expressions
    - no named reference for the purpose of recursion or event binding/unbinding
- the longer the function, the less `=>` helps, the shorter the function, the more `=>` can shine
  - it's reasonable to adopt arrow functions for the place in code where a short inline function is needed and leave the rest as it is
```js
var a = [1,2,3,4,5];

a = a.map( v => v * 2 );

console.log( a );               // [2,4,6,8,10]
```
####Not just shorter syntax, but `this`
- arrow functions are *primarily designed* to alter `this` behavior in a specific way, solving a particular and common pain point with `this`
- inside arrow functions the `this` binding is not dynamic (like in normal functions) but is instead lexical
```js
var controller = {
    makeRequest: function(..){
        btn.addEventListener( "click", () => {
            // ..
            this.makeRequest(..);
        }, false );
    }
};
```
- lexical `this` in the arrow function callback in the snippet now points to the same value as in the enclosing `makeRequest(..)` function
  - `=>` is a syntactic stand-in for `var self = this` (or a `.bind(this)` call)
- **however** using `=>` when `var self = this` *doesn't* need to work in a this-aware function things will get messed up
```js
var controller = {
    makeRequest: (..) => {
        // ..
        this.helper(..);
    },
    helper: (..) => {
        // ..
    }
};

controller.makeRequest(..);
```
- in this case the `this.helper` reference when invoking `controller.makeRequest(..)` fails because t`this` doesn't point to `controller` (as it normally would)
  - it instead lexically inherits `this` from the surrounding scope (global scope and therefore points a the global object in this case)

###`for .. of` Loops
- ES6 adds a `for .. of` loop which loops over the set of values produced by an *iterator*
  - so the value to loop over must be an *iterable* or a vlaue which can be coerced/boxed to an object that is an iterable
    - an iterable is simply an object that is able to produce an iterator (which the loop then uses)
- comparison between `for .. in` and `for .. of` 
```js
var a = ["a","b","c","d","e"];

for (var idx in a) {
    console.log( idx );
}
// 0 1 2 3 4

for (var val of a) {
    console.log( val );
}
// "a" "b" "c" "d" "e"
```
- `for .. in` loops over the keys/indexes in the array and `for .. of` loops over the values
- standard built-in values in JS that are by default iterables
  - Arrays
  - Strings
  - Generators
  - Collections / TypedArrays
- **Note:** plain objects are not by default suitable for `for .. of` looping
  - that's because they dont have a default iterator (which is intentional, not a mistake)

###Regular Expressions
- [unicode flag](https://github.com/getify/You-Dont-Know-JS/blob/master/es6%20%26%20beyond/ch2.md#unicode-flag)
- [sticky flag](https://github.com/getify/You-Dont-Know-JS/blob/master/es6%20%26%20beyond/ch2.md#sticky-flag)
- [Regular Expression `flags`](https://github.com/getify/You-Dont-Know-JS/blob/master/es6%20%26%20beyond/ch2.md#sticky-flag)

###Number Literal Extensions
- [see](https://github.com/getify/You-Dont-Know-JS/blob/master/es6%20%26%20beyond/ch2.md#number-literal-extensions)

###Unicode
- [see](https://github.com/getify/You-Dont-Know-JS/blob/master/es6%20%26%20beyond/ch2.md#unicode)

###Symbols
- `symbol` is a new primitive type in JS
  - unlike the other primitive types, symbols don't have a literal form
```js
var sym = Symbol("some optional description");
typeof sym;     // symbol
```
- `Symbol(..)` cannot and should not be used with `new`
  - it is not a constructor, nor it produces an object
- the parameter passed to `Symbol(..)` is optional and should be a string that gives a description for the symbol's purpose 
  - the description is solely used for the stringification representation of the symbol
```js
sym.toString();     // "Symbol(some optional description)"
```
- the `typeof` output is a new value `"symbol"` that is the primary way to identify a symbol
- similar to how primitive string values are not instances of `String`, symbols are also not instances of `Symbol` 
- the internal value of a symbol itself (referred to as its `name`) is hidden from the code and cannot be obtained
  - about symbol value can be though as an automatically generated, unique string value
- the main point of a symbol is to create a string-like value that can't collide with any other value
- for example a symbol can be used as a constant represting an event name:
```js
const EVT_LOGIN = Symbol( "event.login" );
```
- the symbol EVT_LOGIN can then be used instead of a generic string literal like `"event.literal"`
```js
evthub.listen( EVT_LOGIN, function(data){
    // ..
} );
```
- the benefit is that `EVT_LOGIN` holds a value that cannot be duplicated (accidentally or otherwise) by any other value, so any confusion about which event is being dispatched/handled is impossible 

####Symbol Registry
- one downside to using symbols is that the variables had to be stored in an outer scope, or otherwise somehow stored in a publicly available location, so that all parts of the code that need to use these symbols can access them
- to help the access to these symbols, symbol values can be created with the *global symbol registry*
```js
const EVT_LOGIN = Symbol.for( "event.login" );
console.log( EVT_LOGIN );       // Symbol(event.login)
```
- `Symbol.for(..)` looks in the global symbol registry to see if a symbol is already stored with the provided description text and returns that symbol if so
  - if there's not then it creates one to return
  - so any part of the code can retrieve the symbol from the registry using `Symbol.for(..)` (as long as the matching description name is used)
    - to avoid accidental collisions symbol descriptions should be quite unique for example by using prefixs/context/namespacing 
- a registered symbol's description text(key) can be retrieved using `Symbol.keyFor(..)`
```js
var s = Symbol.for( "something cool" );

var desc = Symbol.keyFor( s );
console.log( desc );            // "something cool"

// get the symbol from the registry again
var s2 = Symbol.for( desc );

s2 === s;                       // true
```
####Symbols as Object Properties
- a symbol used as a property/key of an object is stored in a special way so that the property will not show up in a normal enumeration of the object's properties
```js
var o = {
    foo: 42,
    [ Symbol( "bar" ) ]: "hello world",
    baz: true
};

Object.getOwnPropertyNames( o );    // [ "foo","baz" ]
```
- an object's symbol properties can be retrieved anyway
```js
Object.getOwnPropertySymbols( o );  // [ Symbol(bar) ]
```
- so a property symbol is not actually hidden or inaccessible

##Organization
###Iterators
- an *iterator* is a structured pattern for pulling information from a source in a one-at-a-time fashion
- ES6 introduces an implicit standardized interface for iterators
  - many of JS's built-in data structures will now expose an iterator implementing this standard

####`next()` Iteration

