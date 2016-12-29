#Types & Grammar
##Types
- a type is an intrinsic, built-in set of characteristics that uniquely identifies the behavior of a particular value and distinguishes it from other values
  - for example the number `42` (numeric) is different from the string `"42"`
- there are seven built-in types
  - `null`
  - `undefined`
  - `boolean`
  - `number`
  - `string`
  - `object`
  - `symbol` (added in ES6)
- the `typeof` operator inspects the type of a given value and returns one of the correspondig type and returns a string value of the same name
  - `typeof` can also return  "function"
  - **Note** `null` is *special* in the way that it is buggy when used with `typeof` ==> it returns "object"
    - testing `null` for its type
    ```js
    var a = null;
    (!a && typeof a === 'object'); // true
    ```
- in JS variables don't have types, the value that a variable holds has a type
  - `typeof` operator returns "undefined" for undefined variables *and* even for undeclared variables

##Value vs. Reference
- in JS there are no pointers and you cannot have a reference from one JS variable to another variable
  - a reference in JS points at a (shared) **value** 
    - 10 different references are all references to a single shared value, **none of them are references/pointers to each other**
- the *type* of a value *solely* controls whether that value will be assigned by value-copy or by reference-copy
  - simple values (aka scalar primitives) are *always* assigned/passed by **value-copy**: `null`, `undefined`, `string`, `number`, `boolean` and `symbol`
  - compound values are *always* assigned by **reference copy**: `objects` (including `arrays` and `functions`)
```js
var a = 2;
var b = a; // `b` is always a copy of the value in `a`
b++;
a; // 2
b; // 3

var c = [1,2,3];
var d = c; // `d` is a reference to the shared `[1,2,3]` value
d.push( 4 );
c; // [1,2,3,4]
d; // [1,2,3,4]
// c and d do not own the array, they are just equal references to it
```
- most common way confusion appears is with function parameters
```js
function foo(x) {
    x.push( 4 );
    x; // [1,2,3,4]

    // later
    x = [4,5,6];
    x.push( 7 );
    x; // [4,5,6,7]
}

var a = [1,2,3];

foo( a );

a; // [1,2,3,4]  not  [4,5,6,7]
```
  - when `a` is passed, a copy of the `a` *reference* is assigned to `x`
  - `x` and `a` are seperate references at the same `[1,2,3]` value
  - inside the function it is possible to mutate the value itself eg `push(4)`
  - but a new assignment to x `x = [4,5,6]` is not affection the value where the initial reference `a` is pointing 
    - `a` still points at the modified `[1,2,3,4]` value
  - there is no way to use the x reference to change where a is pointing 
    - could only modifiy the contents of the *shared* value that both a and x are pointing to
- to pass a compound value (*reference-copy* => eg `array`) by *value-copy* manually make a copy of it, so that the passed *reference* does not point to the original anymore 
  ```js
  foo( a.slice() );
  ```
  - slice with no parameters makes a new (shallow) copy of an array by default
- to pass a simple value (scalar primitives) in a way so it can be seen kinda like a *reference* wrap the value in another *compound* value (object, array, etc) that can be passed by *reference-copy* 
  ```js
  function foo(wrapper) {
    wrapper.a = 42;
  }

  var obj = {
      a: 2
  };

  foo( obj );

  obj.a; // 42
  ```

##Natives
- most commonly used natives:
  - `String()` `Number()` `Boolean()` `Array()` `Object()` `Function()` `RegExp()` `Date()` `Error()` `Symbol()`
  - these natives are built-in functions
- each of these natives can be used as a native constructor
  - but what's being constructed might be unexpected
    - for example the result of `new String('abc')` is an object wrapper around the primitive `"abc"` value
    - `typeof` shows that these objects are not their own special *types* but more appropriately they are subtypes of the `object` type 

###Internal Class
- values that are `typeof "object"` (e.g array) are tagged with an internal `class` property
  - rather a *class*ification that related to traditional classes
- this property cannot be accessed directly, but can be revealed indirectly by borrowing the default `Object.prototype.toString(..)` method called against the value
```js
Object.prototype.toString.call( [1,2,3] );          // "[object Array]"

Object.prototype.toString.call( /regex-literal/i ); // "[object RegExp]"
```
  - in this example the classes are `Array` and `RegExp`
  - most of the time the internal class value corresponds to the built-in native constructor
    - however there are no native `Null()` or `Undefined()` constructors but the internal class values are `Null` and `Undefined`
- for other simple primitives like `string`, `number` and `boolean` another behavior kicks in which is usually called *boxing*
  ```js
  Object.prototype.toString.call( "abc" );    // "[object String]"
  Object.prototype.toString.call( 42 );       // "[object Number]"
  Object.prototype.toString.call( true );     // "[object Boolean]"
  ```
  - each of these simple primitives are automatically boxed by their respective object wrappers
    - that's why "String", "Number" and "Boolean" are revealed as their internal class values

###Boxing Wrappers
- primitive values don't have properties or methods
- an object wrapper around is needed the value to access `.length` or `.toString()` 
- JS automatically *boxes* (aka wraps) primitive values to fulfill such accesses
- it is better to let the boxing happen implicitly because browsers perfomance-optimized these use-cases (instead of using the object form manually)
  - prefer literal primitives values `"abc"` or '42' over the object form `new String("abc")` or `new Number(42)`

####Object Wrapper Gotchas
```js
var a = new Boolean( false );

if (!a) {
    console.log( "Oops" ); // never runs
}
```
- Problem: creates object wrapper around the `false` value but objects themselves are "truthy"
  - so using the object behaves oppositely to using the underlying `false` value itself
- manually boxing a primitive value is achieved by using the `Object(...)` function (no new keyword)

###Unboxing
- getting the underlying primitive value out of an object wrapper is achieved by using the `valueOf()` method
```js
var a = new String( "abc" );
var b = new Number( 42 );
var c = new Boolean( true );

a.valueOf(); // "abc"
b.valueOf(); // 42
c.valueOf(); // true
```
- unboxing can also happen implicitly by coercion when using an object wrapper in a way that requires the primitive value
```js
var a = new String( "abc" ); // using the object form
var b = a + ""; // `b` has the unboxed primitive value "abc"

typeof a; // "object"
typeof b; // "string"
```

###Natives as Constructors
####Array
- [here](https://github.com/getify/You-Dont-Know-JS/blob/master/types%20%26%20grammar/ch3.md#array)
####Object, Function and RegExp
- [here](https://github.com/getify/You-Dont-Know-JS/blob/master/types %26 grammar/ch3.md#arrayj)
####Date and Error
- the `Date(..)` and `Error(..)` native constructors are much more useful than the other natives because there is no literal form for either
- `new Date(..)` accepts optional arguments to specify the date/timestamp
  - if ommited the current date/time is assumed
- most common reason to construct a date object is get the current timestamp value (integer of miliseconds since Jan 1, 1970)
  - this is achieved by calling `getTime()` on a date object instance
  - even easier by calling the static helper function `Date.now()`
- calling `Date(..)` without `new` keyword in front of it returns a *string* representation of the current time
- main reason to create an error object is, that it captures the current execution stack context into the object
  - this stack context includes the function call-stack and the line-number where the error object was created, which makes debugging easier
- typically used with the `throw` operator
```js
function foo(x) {
    if (!x) {
        throw new Error( "x wasn't provided" );
    }
    // ..
}
```
- error objects generally have a `message` property and sometimes other properties like `type`
  - however it is usually best to call `toString()` on a error object to get a formatted error message
####Symbol
- primarily designed for special built-in behaviors of ES6 constructs
  - several predefined symbols accessed as static properties of the `Symbol` function object like `Symbol.create` or `Symbol.iterator`
  ```js
  obj[Symbol.iterator] = function(){ /*..*/ };
  ```
  - but also possible to define own symbols
    - use `Symbol(..)`(`new` is not allowed!) 
- symbols are special "unique" values that can be used as properties ons objects with little fear of any collision
  - you cannot see or access the actual value of a symbol from the programm nor from the developer console
  - evaluating a symbol in the console returns something like `Symbol(Symbol.create)`
- `Symbol`s are not objects, they are simple scalar primitives

#####Native Prototypes
- each built-in native constructor has its own `.prototype` object (`Array.prototype`, `String.prototype` etc.)
- these objects contain behavior unique to their particular object subtype
- for example all string objects and `string` primitives (via boxing) have access to default behavior (in form of methods) on the `String.prototype`
- **Note:** by convention `String.prototype.XYZ` is shortened to `String#XYZ` (likewise for all the other `.prototype`s)
