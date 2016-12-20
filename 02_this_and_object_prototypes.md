# *this* & Object Prototypes
### Call-site
- `this` is a binding made for each function invocation, based entirely on how the function is called (its call-side) ==> inspect the call-site to answer what `this` is referring to
- to find out where a function is called from inspect the **call-stack** (the stack of functions that have been called to get to the current moment in execution)
  - the relevant call-site is *in* the invocation *before* the currently executing function
```js
function baz() {
    // call-stack is: `baz`
    // so, our call-site is in the global scope
    console.log( "baz" );
    bar(); // <-- call-site for `bar`
}

function bar() {
    // call-stack is: `baz` -> `bar`
    // so, our call-site is in `baz`
    console.log( "bar" );
    foo(); // <-- call-site for `foo`
}

function foo() {
    // call-stack is: `baz` -> `bar` -> `foo`
    // so, our call-site is in `bar`
    console.log( "foo" );
}

baz(); // <-- call-site for `baz`
```
  - find the actual call-site from the call-stack to find out what `this` is referring to
  - visualize the call-stack by looking at the chains of function calls in order (use developer tools to avoid mistakes)
- rules of how the call-site determines where `this` points during execution of a function

### Default Binding
- most common case of function calls ==> standalone function invocation 
  - default catch-all rule when no other rules apply
```js
function foo() {
    console.log( this.a );
}

var a = 2;

foo(); // 2
```
- **Note** the global variable `var a = 2` *is* synonymous with global-object properties of the same name (e.g window.a)
- `this` resolves to the global variable `a`because the *default binding* applies so `this` points at the global object 
- `foo()` is called with plain, undecorated function reference so none of the other rules apply
- **Note** if the contents of `foo()` are running in strict mode (the call-site is irrelevant) the global object is not eligible for *default binding* so `this` is set to `undefined` 

### Implicit(indirect) Binding
- does the call-site have a context object?
```js
function foo() {
    console.log( this.a );
}

var obj = {
    a: 2,
    foo: foo
};

obj.foo(); // 2
```
- because `obj` is the `this` for the `foo()` call, `this.a` is synonymous with `obj.a`
- **Note** regardless of whether `foo()` is initially declared *on* `obj` or is added as a reference later (see above) the **function** is never really "owned" or "contained" by the `obj` object
- however, the call-site *uses* the `obj` context to **reference** the function (the object owns/contains the **function reference**at the time the function is called)
- when there is a context object preceeding a function reference the *implicit binding* rule says that it is *that* object which should be used for the functions `this`
- **Implicitly Lost**
  - confusion might occur when an *implicitly bound* function loses that binding and falls back to the *default binding* (global object or undefined in strict mode)
  ```js
  function foo() {
    console.log( this.a );
  }

  var obj = {
      a: 2,
      foo: foo
  };

  var bar = obj.foo; // function reference/alias!

  var a = "oops, global"; // `a` also property on global object

  bar(); // "oops, global"
  ```
  - `bar` is just another reference to `foo` and not to `obj.foo` and the call-site of `bar()` is plain/undecorated and thus default binding applies
  - the same happens when passing a callback function:
  ```js
  function foo() {
    console.log( this.a );
  }

  function doFoo(fn) {
      // `fn` is just another reference to `foo`

      fn(); // <-- call-site!
  }

  var obj = {
      a: 2,
      foo: foo
  };

  var a = "oops, global"; // `a` also property on global object

  doFoo( obj.foo ); // "oops, global"
  ```
- **Note** some JS libraries force a callback to have a `this` which points for example at the DOM Element that triggered the event
  - this can be useful sometimes and sometimes troublesome
  - when `this` is changed unexpectedly the control of how a callback function reference will be executed is lost (see [fixing this]())

### Explicit Binding
- trough their prototype, JS functions have access to `call(...)` and `apply(...)`
  - they both take, as their first parameter, an object to use for `this` and then invoke the function with that `this` specified
  - because of directly stating `this` , this is called *explicit binding*
  - they are identical but behave differently with the way the take their additional parameters
```js
function foo() {
  console.log( this.a );
}

var obj = {
    a: 2
};

// invoking foo with explicitly binding 'this' to be 'obj'
foo.call( obj ); // 2 
```
- this still does not prevent a function of "losing" its intended `this` binding when it just points at a function reference of an object 
- **Solution** ==> Hard Binding
  ```js
  function foo() {
    console.log( this.a );
  }

  var obj = {
      a: 2
  };

  var bar = function() {
      foo.call( obj );
  };

  bar(); // 2
  setTimeout( bar, 100 ); // 2

  // `bar` hard binds `foo`'s `this` to `obj`
  // so that it cannot be overriden
  bar.call( window ); // 2
  ```
  - `bar()` manually calls `foo.call(obj)` thereby forces invoking `foo` with `obj` as `this`
  - this is both *explicit* and *strong* so it is called *hard binding*
- since *hard binding* is so common, ES5 introduced the built-in utility `bind`
  ```js
  function foo(something) {
      console.log( this.a, something );
      return this.a + something;
  }

  var obj = {
      a: 2
  };

  var bar = foo.bind( obj );

  var b = bar( 3 ); // 2 3
  console.log( b ); // 5
  ```
  - `bind(...)` returns a new function that is hard-coded to call the original function with the `this` context as specified
  - **Note** bind has a .name property that derives from the original target function (which is the function call name that should show up in a stack trace)
- many libraries and many new built in functions provide an optional parameter called "context" or "thisArg" to specify a particular `this`

### `new` Binding
- in JS constructors are **just functions** that happen to be called with the `new` operator in front of them
  - they are not attached to classes, nor do they instantiate a class
  - they are no special types of functions
  - they are regular functions that are "hijacked" by the use of `new` in their invocation
- calling a function with `new` in front of it, makes that function call a *constructor call*
  - there's no such things as constructor functions, but rather construction calls *of* functions
- invoking a function with `new` in front of it (constructor call) the following happens
  1. brand new object is created(constructed)
  2. newly created object is Prototype-linked
  3. newly created object is set as the `this` binding for that function call (*new binding*)
  4. unless the function returns its own alternate object, the `new`-invoked function call will automatically return the newly created object

### Precedence
- *new binding* is more precedent than *implicit binding*
  - a hard bound call is able to be overridden with *new*
  - if the function is called with `new`, `this` is that newly created object
- *explicit binding* takes precedence over *implicit binding*
  - if the function is called with `call` or `apply` or even hidden inside a `bind` hard binding `this` is the explicitly specified object
  - if the function is called with a context (implicit binding) `this` is *that* context object
- *default binding* has the lowest priority
  - in strict mode the default `this` will be `undefined` and the `global` object otherwise

### Misc
- if `null` or `undefined` is passed as a binding parameter to `call`, `apply` and `bind` those values are ignored and instead the *default binding* rule applies
  - if a function doesnt care about `this` `null` might be a reasonable placeholder
  - or use a completely empty object(DMZ) for this case to prevent side effects
- it's quite common to use `apply(...)` for using an array of values as parameters
  - ES6 has the `...` spread operator to avoid a `this` binding if it's unnecessary => `foo(...[1,2])`
- `bind(...)` can curry parameters (pre-set values)
- arrow functions don't follow the rules above but adopt the `this` from it's enclosing function call (similar to `self = this`)
- [Softening Binding](https://github.com/getify/You-Dont-Know-JS/blob/master/this%20%26%20object%20prototypes/ch2.md#softening-binding)


## Objects
- two forms: 
  1. declarative (literal) form:
  ```js
  var myObject = {
    key: value,
    key2: value2
    // ...
  }
  ```
  2. constructed form (uncommon):
  ```js
  var myObject = new Object();
  myObject.key = value;
  myObject.key2 = value2;
  ```
  These result in the same sort of object, the only difference is that the literal can take multiple key/value pairs at once
- six primary/primitive types (not *object* types): string, number, boolean, null, undefined, object
  - the first 5 are not themselves objects
- "everything in JavaScript is an object" **is not true**

### Built-in Objects (object sub-types)
- String, Number, Boolean, Object, Function, Array, Date, RegExp, Error
- these are actually just built-in functions
  - therefore can be used as a constructor (with `new`), which results in a newly *constructed* object of the specified sub-type
  ```js
  var strPrimitive = "I am a string";
  typeof strPrimitive;                            // "string"
  strPrimitive instanceof String;                 // false

  var strObject = new String( "I am a string" );  // object created by "String" constructor
  typeof strObject;                               // "object"
  strObject instanceof String;                    // true
  ```
  - `strPrimitive` is  not an object, it is a primitive literal and immutable
    - to perform operations on it (e.g check length) a `String` object is required
    - to allow this JS automatically coerces a "string" primitive to a `String` object when necessary
      - same thing would happen between a literal primitive `42` and a `new Number(42)` object wrapper, when using a method like `12.453.toFixed(2)`
      - likewise for `Boolean` objects from `"boolean"` primitives
- `null` and `undefined` have no object wrapper form, only their primitive values
- `Date` values can *only* be created with the constructing object form (no literal counterpart)
- `Error` objects are rarely created explicitly (usually created automatically when exceptions are thrown)
- Arrays
  - the "." operator requires an `Identifier` compatible property name whereas "[]" can take any UTF-8/unicode compatible strings as the name for the property
    - that is why arrays use `[ ]` access since their properties are positive integers
  - in objects, property names are always strings any other value besides a `string`(primitive) will first be converted to a string, including numbers which are used as array indexes
  - arrays are objects so it is possible to add properties (does not change the result of arr.length)
    - a string containing a number as a property will end up being added to the array (arr.length will increase)
- Duplicating Objects
  - if an object is JSON-safe it can be duplicated by serializing it to a JSON string and then re-parsing it to an Object
  ```js
  var newObj = JSON.parse( JSON.stringify( someObj ) );
  ```
  - a shallow (not deep) copy is achieved by using ES6's `Object.assign(..)` which takes a *target* object as first parameter and one or more *source* objects as subsequent parameters
    - it iterates over all enumerable, owned keys (immdediately present) on the `source` objects and copies them via `=` assignment to the target

### Property Descriptors
- properties are descriped in terms of a **property descriptor**
  ```js
  var myObject = {
    a: 2
  };

  Object.getOwnPropertyDescriptor( myObject, "a" );
  // {
  //    value: 2,
  //    writable: true,
  //    enumerable: true,
  //    configurable: true
  // }
  ```
  - this includes much more than just its `value` of `2`
- with `Object.defineProperty(..)` new properties can be added, or existing ones modified
  ```js
  var myObject = {};
  Object.defineProperty( myObject, "a", {
      value: 2,
      writable: true,
      enumerable: true,
      configurable: true
  } );
  ```

**Writable**
- `true` if it's possible to change the property's value, `false` otherwise
**Configurable**
- `true` if it's possible to modify the other property descriptor definitions
- `false` also prevents to use `delete myObject.myProperty` to remove an existing property
- **Note** even if `configurable` is `false` `writable` can always be changed from `true` to `false` but not back (TypeError)
**Enumerable**
-  controls if a property will show up in certain object-property enumerations (e.g `for .. in`)
- set to false to prevent showing up in such enumerations even though it's still completely accessible, set to true to keep it present
- normal user-defined properties are defaulted to `enumerable`(true)
