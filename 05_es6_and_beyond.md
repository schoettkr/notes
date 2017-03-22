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
- an iterable, for example an array, can produce an iterator to consume it values:
```js
var arr = [1,2,3];

var it = arr[Symbol.iterator]();

it.next();      // { value: 1, done: false }
it.next();      // { value: 2, done: false }
it.next();      // { value: 3, done: false }

it.next();      // { value: undefined, done: true }
```
- `it` doesn't report `true` when recieving the `3` value, `next()` has to be called again to get the complete signal `done: true`
- each time the method located at `Symbol.iterator` is invoked on this `arr` value, it will produce a new fresh iterator  
  - most structures (including strings or collections for example) will do the same, including all built-in data structures in JS

####Optional: `return(..)` and `throw(..)`
- these optional methods on the iterator interface are not implemented on most of the built-in iterators
- `return(..)` sends a signal to an iterator that the consuming code is complete and will not be pulling any more values from it
  - can be used to notify the producer to perform any cleanup it may need to do
- `throw(..)` is used to signal an exception/error to an iterator
  - it does not necessarily imply a complete stop of the iterator as `return(..)` does

####Iterator Loop
- if an iterator is also an iterable, it can be used directly with the `for .. of` loop
  - an iterator is made an iterable by giving it a `Symbol.iterator` method that returns the iterator itself
- [see](https://github.com/getify/You-Dont-Know-JS/blob/master/es6%20%26%20beyond/ch3.md#iterator-loop)

####Custom Iterators
- [see](https://github.com/getify/You-Dont-Know-JS/blob/master/es6%20%26%20beyond/ch3.md#custom-iterators)

###Generators
- [see](https://github.com/getify/You-Dont-Know-JS/blob/master/es6%20%26%20beyond/ch3.md#generators)
- [and especially](https://github.com/schoettker/notes/blob/master/04_async_and_performance.md#generators)

###Modules
- modules are the single most important code organization pattern in JS

####The Old Way
- the traditional module pattern is based on an outer function with inner variables and functions and a returned "public API" with methods that have closure over the inner data
```js
function Hello(name) {
    function greeting() {
        console.log( "Hello " + name + "!" );
    }

    // public API
    return {
        greeting: greeting
    };
}
var me = Hello( "Lenno" );
me.greeting();          // Hello Lenno!
```
- this `Hello(..)` module can produce multiple instances by being called subsequent times

####Moving Forward
- ES6 does not longer rely on enclosing functions and closure to provide module support
  - ES6 modules have first class syntactic and functional support
- there're a few conceptual differences with ES6 modules compared to traditional modules
  1. ES6 uses file-based modules (one module per file)
    - there's no standardized way of combining multiple modules into a single file
    - that means loading ES6 modules in a web application, will be an individual load (not as a large bundle in a single file)
  2. the API of an ES6 module is static
  3. ES6 modules are singletons
    - only one instance of the module, which maintains its state
  4. the properties and methods exposed an a module's API are not just normal assignments/values/references - they are actual bindings to the identifiers in the inner module definition (almost like pointers)
  5. importing a module is the same thing as statically requesting it to load

####The New Way
- the two main new keywords that enable ES6 modules are `import` and `export`
  - both must always appear in the top-level scope of their respective usage, cannot be inside an `if` conditional for example (outside all blocks & functions)

#####`export`ing API Members
- `export` is either put in front of a declaration or used as an operator with a special list of bindings to export
```js
export function foo() {
    // ..
}

export var awesome = 42;

var bar = [1,2,3];
export { bar };
```
- another way to express the same exports:
```js
function foo() {
    // ..
}

var awesome = 42;
var bar = [1,2,3];

export { foo, awesome, bar };
```
- these are all called *name exports*
  - because in effect the name binding of the variables/functions/etc. are exported
- anything that's *not labeled* with `export` stays private inside the scope of the module
  - although somethink like `var bar = ..` looks like it is declared at the top-level global scope, the top-level scope is actually the module itself, there is no global scope in modules
    - Modules *do still* have access to `window` and all the "globals" that hang of it, just to as lexical top-level scope (but it is advised to stay away from globals in modules)
- a module member can also be renamed (aka alias) during named export
```js
function foo() { .. }
export { foo as bar };
```
- module exports are not just normal assignments of values or references, actually when exporting something, a binding (kinda like a pointer) to that thing (variable,function,etc) is exported
- within a module, if the value of a already exported variable (a binding to it) is changed, the imported binding will resolve to the current(updated) value
```js
var awesome = 42;
export { awesome };
// later
awesome = 100;
```
- when this module is imported, regardless of when, once that `awesome = 100` assignment has happened , the imported binding resolves to the `100` value, not `42`
  - that's because the binding is in essence a reference/a pointer to the new `awesome` variable itself, rather than a copy of its value
- although `export` can be used multiple times inside a module's definition, ES6 definitely prefers the approach where a module has a single export (default export)
  - the name of the binding is literally `default` (they can be renamed which is common)
  - there can only be one `default` per module definition
- there's a subtle nuance to default export syntax:
```js
function foo(..) {
    // ..
}
export default foo;
```
vs
```js
function foo(..) {
    // ..
}
export { foo as default };
```
- the first snippet exports a binding to the function expression value at that moment, *not* to the identifier `foo`
  - in other words `export default ..` takes an expression
  - later assigning `foo` to a different value inside the module, the module import still reveals the function originally exposed, not the new value
- in the second snippet the default export binding is actually to the `foo` identifier rather than its value 
  - that results in the behavior that if `foo`'s value is changed, the value seen on the import side will also be updated
- the couraged patterns for exporting APIs with more than one member look like this:
```js
export default function foo() { .. }
export function bar() { .. }
export function baz() { .. }
```
or alternatively
```js
function foo() { .. }
function bar() { .. }
function baz() { .. }
export { foo as default, bar, baz, .. };
```
#####`import`ing API Members
- to import certain specific named members of a module's API into your top-level scope, use this syntax
```js
import { foo, bar, baz } from "foo";
```
- **Note:** the `{ .. }` may look like an object literal, however its form is special just for modules
- the `foo`, `bar` and `baz` identifiers must match named exports on the module's API
  - they're bound as top-level identifiers in the current scope
- the `"foo"` string is called a *module specifier* and can't be a variable holding the string value
  - the module loader will interpret this string as an instruction of where to find the desired module, either as a URL path or a local filesystem path
- bound indentifiers can be renamed as:
```js
import { foo as theFooFunc } from "foo";
theFooFunc();
```
- ES6 philosophy suggests to only import the specific bindings from a module that are needed

####Circular Module Dependency
- [see](https://github.com/getify/You-Dont-Know-JS/blob/master/es6%20%26%20beyond/ch3.md#circular-module-dependency)

####Module Loading
- [see](https://github.com/getify/You-Dont-Know-JS/blob/master/es6%20%26%20beyond/ch3.md#module-loading)

###Classes
- [Notes](https://github.com/schoettker/notes/blob/master/02_this_and_object_prototypes.md#class-theory--object-oriented-design)
- add this section later: [see](https://github.com/getify/You-Dont-Know-JS/blob/master/es6%20%26%20beyond/ch3.md#classes)

##Async Flow Control
- already [here](https://github.com/schoettker/notes/blob/master/04_async_and_performance.md)
- nothing much new, but concise -> [see](https://github.com/getify/You-Dont-Know-JS/blob/master/es6%20%26%20beyond/ch4.md)

##Collections
- in ES6 some of the most useful (and performance optimizing) data structure abstractions have been added as native components of the language

###TypedArrays (ES5)
- typed arrays *do not mean* an array of specific type of values (`number` or `string`)
- typed arrays are about providing structured access to binary data using array-like semantics (indexed access etc.)
  - the "type" refers to a "view" layered on type of the buckets of bits, which is essentially a mapping of whether the bits should be viewed as an array of 8-bit signed integers, 16-bit signed integers and so on
- such bit-bucket is called a "buffer" and it's most directly constructed with the `ArrayBuffer(..)` constructor
```js
var buf = new ArrayBuffer( 32 );
buf.byteLength;                         // 32
```
- `buf` is now a binary buffer that is 32-bytes long (256-bits), that's pre-initialized to all `0`s
  - a buffer by itself doesn't really allow any interaction except for checking its `byteLength` property
- on top of this array buffer can be layered a "view", which comes in the form of a typed array
```js
var arr = new Uint16Array( buf );
arr.length;                         // 16
```
- `arr` is a typed array of 16-bit unsigned integers mapped over the 256-bit `buf` buffer, resulting in 16 elements
  - the buffer has a size of 32 bytes (256 bits) 256 : 16 bits = 16 elements

####Endianness (Byte-Reihenfolge)
- [see](https://github.com/getify/You-Dont-Know-JS/blob/master/es6%20%26%20beyond/ch5.md#endianness)

####Multiple Views
- [see](https://github.com/getify/You-Dont-Know-JS/blob/master/es6%20%26%20beyond/ch5.md#multiple-views)

####TypedArray Constructors
- [see](https://github.com/getify/You-Dont-Know-JS/blob/master/es6%20%26%20beyond/ch5.md#typedarray-constructors)

###Maps
- objects are the primary mechanism for creating unordered key/value-pair data structures, otherwise known as maps
  - the major drawback with objects-as-maps is the inability to use a non-string value as a key
- ES6 introduces `Map(..)` to overcome this
```js
var m = new Map();

var x = { id: 1 },
    y = { id: 2 };

m.set( x, "foo" );
m.set( y, "bar" );

m.get( x );                     // "foo"
m.get( y );                     // "bar"
```
- the only drawback is that the `[ ]` bracket access syntax for setting and retrieving values can't be used, but `get(..)` and `set(..)` work perfectly
- deleting an element from a map is achieved by using the `delete(..)` method (not the `delelte` operator)
```js
m.set( x, "foo" );
m.set( y, "bar" );
m.delete( y );
```
- an entire map's contents can be cleared with `clear()` and the length of a map (number of keys) can be retrieved with `size` (not `length`)
```js
m.set( x, "foo" );
m.set( y, "bar" );
m.size;                         // 2
m.clear();
m.size;                         // 0 
```
####Map Values
- to get the list of values from a map, `values(..)` is used, which returns an iterator
```js
var m = new Map();

var x = { id: 1 },
    y = { id: 2 };

m.set( x, "foo" );
m.set( y, "bar" );

var vals = [ ...m.values() ];

vals;                           // ["foo","bar"]
Array.from( m.values() );       // ["foo","bar"]
```
- iterating over a map's entries can be done by using `entries()` 
```js
var m = new Map();

var x = { id: 1 },
    y = { id: 2 };

m.set( x, "foo" );
m.set( y, "bar" );

var vals = [ ...m.entries() ];

vals[0][0] === x;               // true
vals[0][1];                     // "foo"

vals[1][0] === y;               // true
vals[1][1];                     // "bar"
```
####Map Keys
- to get the list of keys `keys()` is used, which returns an iterator over the keys in the map
```js
var m = new Map();

var x = { id: 1 },
    y = { id: 2 };

m.set( x, "foo" );
m.set( y, "bar" );

var keys = [ ...m.keys() ];

keys[0] === x;                  // true
keys[1] === y;                  // true
```
- to determine if a map has a given key, use `has(..)`:
```js
var m = new Map();

var x = { id: 1 },
    y = { id: 2 };

m.set( x, "foo" );

m.has( x );                     // true
m.has( y );                     // false
```
- Maps essentially allow to associate some extra pieces of information (the value) with an object (the key) without actually putting that information on the object itself

###WeakMaps
- WeakMaps are a variation on maps and have most of the same external behavior but differ underneath in how the memory allocation works
  - they do not have a `size` property or `clear()` method
- WeakMaps only take objects as keys
  - those objects are held *weakly*
    - this means if the object itself is garbage-collected(GC) the entry in the WeakMap is also removed
    - they only hold its *keys* weakly, not its values
- WeakMaps are particularly useful if the object is not one that's completely controlled by the dev, such as a DOM element
  - if the object used as a key can be deleted and should be GC-eligible when it is, then a WeakMap is a more appropriate option

###Sets
- a set is a collection of unique values (duplicates are ignored)
```js
var s = new Set();

var x = { id: 1 },
    y = { id: 2 };

s.add( x );
s.add( y );
s.add( x );

s.size;                         // 2

s.delete( y );
s.size;                         // 1

s.clear();
s.size;                         // 0
```
- the API for a set is similar to map
  - the `add(..)` method takes the place of the `set(..)` method, and ironically there's no `get(..)` method
  - a set doesnt need a `get(..)` because you don't retrieve a value from a set, but rather test if it is present or not, using `has(..)`
```js
var s = new Set();
var x = { id: 1 },
    y = { id: 2 };
s.add( x );
s.has( x );                     // true
s.has( y );                     // false
```
- [Set Iterators](https://github.com/getify/You-Dont-Know-JS/blob/master/es6%20%26%20beyond/ch5.md#set-iterators)

#####WeakSets
- whereas a WeakMap holds its keys weakly, a WeakSet holds its values weakly

##API Additions
- ES6 adds many static properties and methods to various built-in natives and objects

###`Array`
####`Array.of(..)` Static Function
- one quirk with the `Array(..)` constructor is that if there's only one argument passed and that is a number, instead of making an array with one element holding that number, an empty array is constructed with a `length` property equal to that number
- `Array.of(..)` replaces `Array(..)` as the preferred function-form constructor for arrays, because it does not have that special single-number-argument case

####`Array.from(..)` Static Function
- an *"array-like object"* in JS is an object that has a `length` property (zero or higher) on it
- it's been quite common to need to transform them into an actual array, so that various `Array.prototype` methods (map, indexOf, etc.) are available to use with it
- `Array.from(..)` approaches this and can also copy an array (new alternative to using slice)
```js
var arr = Array.from( arrLike );
var arrCopy = Array.from( arr );
```
- `Array.from(..)` looks to see if the first argument is an iterable and if so, it uses the iterator to procude values to "copy" into the returned array
- but if an array-like object is passed as the first argument, it behaves basically the same as slice or apply does
  - which is that it simply loops over the value, accessing numerically named properties from `0` up to whatever the value of `length` is
- `Array.from(..)` never produces empty slots
- `Array.from(..)` has another helpful trick: the second argument, if provided, is a mapping callback (almost the same as the regular `Array#map(..)` expects) which is called to map/transform each value from the source to the returned target
  - an optional third argument can be used to specify the `this` binding for the callback passed as the second argument (`undefined` if omitted)
```js
var arrLike = {
    length: 4,
    2: "foo"
};

Array.from( arrLike, function mapper(val,idx){
    if (typeof val == "string") {
        return val.toUpperCase();
    }
    else {
        return idx;
    }
} );
// [ 0, 1, "FOO", 3 ]
```
- [Creating Arrays and Subtypes](https://github.com/getify/You-Dont-Know-JS/blob/master/es6%20%26%20beyond/ch6.md#creating-arrays-and-subtypes)

####`copyWithin(..)` Prototype Method
- is a new mutator method available to all arrays
- copies a portion of an array to another location in the same array, overwriting whatever was there before
- the arguments are *target* (the index to copy to), *start* (the inclusive index to start the copying from) and optionally *end* (the exclusive index to stop copying)
  - if any argument is negative, they're taken to be relative from the end of an array
```js
[1,2,3,4,5].copyWithin( 3, 0 );         // [1,2,3,1,2]

[1,2,3,4,5].copyWithin( 3, 0, 1 );      // [1,2,3,1,5]

[1,2,3,4,5].copyWithin( 0, -2 );        // [4,5,3,4,5]

[1,2,3,4,5].copyWithin( 0, -2, -1 );    // [4,2,3,4,5]
```
- `copyWithin(..)` does not extend the array's length, copying stops when the end of the array is reached

####`fill(..)` Prototype Method
- filling an existing array entirely (or partially) with a specified value is natively supported as of ES6
```js
var a = Array( 4 ).fill( undefined );
a;
// [undefined,undefined,undefined,undefined]
```
- `fill(..)` optionally takes *start* and *end* parameters, which indicate a subset portion of the array to fill
```js
var a = [ null, null, null, null ].fill( 42, 1, 3 );

a;                                  // [null,42,42,null]
```
####`find(..)` Prototype Method
- the most common way to search for a value in an array has been `indexOf(..)` 
- ES6's `find(..)` works basically the same as ES5's `some(..)`, except that once the callback returns a `true`/truthy value, the actual array value is returned
```js
var a = [1,2,3,4,5];

a.find( function matcher(v){
    return v == "2";
} );                                // 2
a.find( function matcher(v){
    return v == 7;                  // undefined
});
```
####`findIndex(..)` Prototype Method
- finds the positional index of the matched value
```js
var points = [
    { x: 10, y: 20 },
    { x: 20, y: 30 },
    { x: 30, y: 40 },
    { x: 40, y: 50 },
    { x: 50, y: 60 }
];

points.findIndex( function matcher(point) {
    return (
        point.x % 3 == 0 &&
        point.y % 4 == 0
    );
} );                                // 2

points.findIndex( function matcher(point) {
    return (
        point.x % 6 == 0 &&
        point.y % 7 == 0
    );
} );                                // -1
```
####`entries(..), values(..), keys(..)` Prototype Method
- `Array` might not be thought of traditionally as a "collection", but it is one in the sense that if provides these same iterator methods: `entries(..), values(..), keys(..)` 
```js
var a = [1,2,3];
[...a.values()];                    // [1,2,3]
[...a.keys()];                      // [0,1,2]
[...a.entries()];                   // [ [0,1], [1,2], [2,3] ]
[...a[Symbol.iterator]()];          // [1,2,3]
```
###`Object`
- a few additional static helpers have been added to `Object`

####`Object.is(..)` Static Function
- makes value comparisons in an even more stict fashion than `===`
- shouldn't be used as a replacement for the strict equality operator, however in cases where it's necessary to strictly identify `NaN` and `-0` `Object.is(..)` is the preferred option

####`Object.getOwnPropertySymbols(..)` Static Function
- symbols are likely going to be mostly used as special(meta) properties on objects, so `Object.getOwnPropertySymbols(..)` was introduced to retrieve only the symbol properties directly on an Object
```js
var o = {
    foo: 42,
    [ Symbol( "bar" ) ]: "hello world",
    baz: true
};
Object.getOwnPropertySymbols( o );  // [ Symbol(bar) ]
```
####`Object.setPrototypeOf(..)` Static Function
- sets the Prototype of an object for the purposes of *behavior delegation*

####`Object.assign(..)` Static Function
- simplified algorithm for copying/mixing one object's properties into another
- the first argument is the *target* and any other arguments passed are the *sources* which will be processed in listed order
- for each source, its enumerable and own (not inherited) keys, including symbols, are copied as if by plain `=` assignment
- returns the target object

###`Math`
- ES6 adds several [new mathematic utilities](https://github.com/getify/You-Dont-Know-JS/blob/master/es6%20%26%20beyond/ch6.md#math)

###`Number`
- ES6 adds some additional properties and functions to assist with common numeric operations
- [see](https://github.com/getify/You-Dont-Know-JS/blob/master/es6%20%26%20beyond/ch6.md#number)

###`String`
- [see](https://github.com/getify/You-Dont-Know-JS/blob/master/es6%20%26%20beyond/ch6.md#string)

##[Meta Programming](https://github.com/getify/You-Dont-Know-JS/blob/master/es6%20%26%20beyond/ch7.md)

##[Beyond ES6](https://github.com/getify/You-Dont-Know-JS/blob/master/es6%20%26%20beyond/ch8.md)
