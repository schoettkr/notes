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
