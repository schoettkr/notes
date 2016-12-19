# *this* & Object Prototypes
## Call-site
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

