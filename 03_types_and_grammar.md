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

##Coercion
- converting a value from one type to another is often called:
  - "type casting" when done *explicitly*
  - "coercion" when done *implicitly* (forced by the rules of how the value is used)
- JS coercion always results in one of the scalar primitives (likes `string`, `number`, `boolean`) 
  - there is no coercion that results in a complex value like `object` or `function`
  - *boxing* (wrapping scalar primitive values in their `object` counterparts) is not really coercion in an accurate sense
- explicit coercion = obvious from looking at the code that a type conversion is intentionally occuring
- implicit coercion = type conversion will occur as a less obvious side effect of some other intentional operation
```js
var a = 42;
var b = a + "";         // implicit coercion
var c = String( a );    // explicit coercion
```
###Abstract Value Operations
- basic rules how values become a `string`, `number` or `boolean`
- ES5 spec defines several "abstract operations" (internal only operation) with the rules of value conversion

####ToString
- any non-string value is coerced into a string representation by the `YoString` abstract operation
- built-in primitives have natural stringifications
  - `null` becomes `"null"`
  - `undefined` becomes `"undefined"`
  - `true` becomes `"true"`
  - `numbers` are expressed in the expected way but very small/large numbers are represented in exponent form
  - regular objects will return the *internal* `class` (e.g `"[object Object]"`)
    - the way an object is coerced into a string technically goes through the `ToPrimitive` abstract operation
  - arrays have an overriden default `toString()` that stringifies all its values with "," in between each value

#######JSON Stringification
- this stringification is not exactly the same thing as coercion but it is related to the `ToString` values above
- basically behaves the same as `toString()` coercions except that the serialization result is *always* a `string`
- any JSON-safe value can be stringified by `JSON.stringify(..)`
  - Json-safe ==> any value that can be represented validly in a JSON representation
  - **not** JSON-safe: `undefined`s, `function`s, `symbol`s and `object`swith circular references (where property references in an object structure create a never-ending cycle through each other)
    - `JSON.stringify(..)` will automatically omit these values if it comes across them 
      - if found in an array that value is replaced by `null`
      - if found as an objects property, that property will be excluded
- optional second argument that can be passed to `JSON.stringify` is called *replacer*
  - this argument can either be an `array` or a `function`
  - it is used to customize the recursive serialization of an `object` by providing a filtering mechanism for which properties should and should not be included
  - if a replacer is an array it should be an array of strings, which will specify a property name that is allowed to pass
  - if a replacer is a function it will be called once for the object itself and then once for each property in the object and each time is passed two arguments: key and value
    - to skip a key return `undefined` else return the value provided
- optional third argument that can be passed to `JSON.stringify` is called *space*
  - space can be a positive integer to indicate how many space characters should be used at each indentation level

####ToNumber
- if any non-`number` value is used in a way that requires it to be a `number` (e.g mathematical operation) the ES5 spec defines the `ToNumber` abstract operation
  - for example: `true` becomes `1`, `false` becomes `0`, `undefined` becomes `NaN` and `null` becomes `0`
- `ToNumber` for a `string` value essentially works for the most part like the rules/syntax for numeric literals
  - if it fails the result is `NaN`
- Objects (and arrays) will first be converted to their primitive value equivalent and the resulting value (if a primitive but not already a `number`) is coerced to a `number`

####ToBoolean
######Falsy Values
- all of JS's values can be divided into two categories:
  - values that will become false if coerced to boolean
  - everything else (which will obviously become true)
- the so-called falsy values:
  - `undefined`
  - `null`
  - `false`
  - `+0`, `-+0` and `NaN`
  - `""`
- JS doesn't really define a "truthy" list 
  - mostly the spec implies that **anything not explicitly on the falsy list is therefore truthy**
- **[falsy objects?!]**(https://github.com/getify/You-Dont-Know-JS/blob/master/types%20%26%20grammar/ch4.md#falsy-objects)

###Explicit Coercion
####Explicitly: Strings <--> Numbers
- use the built-in `String(..)` and `Number(..)` functions (native constructors) to coerce between explicitly between `string`s and `number`s
  - do not use `new` keyword in front of them because we are not creating object wrappers
- `String(..)` coerces from any other value to a primitive `string` value using the rules of the `ToString` operation
- `Number(..)` coerces from any other value to a primitive `number` value using the rules of the `ToNumber` operation
- another way:
```js
var a = 42;
var b = a.toString();

var c = "3.14";
var d = +c;

b; // "42"
d; // 3.14
```
- calling `toString()` seems explicit but there is some implicitness going on
  - `toString()` cannot be called on a primitive value like `42` so JS automatically boxes `42` in an object wrapper so it can be called against that object
- `+c` is showcasing the *unary operator* form (operator with only one operand) of the `+` operator
  - instead performing mathematic addidtion (or string concatenation) the unary `+` explicitly coerces its operand `c` to a `number` value
  - the unary `-` operator also coerces like `+` does but also flips the sign of the number

####`Date` to `number`
- the unary `+` operand can also coerce a `Date` object into a `number`
- the result is the unix timestamp (miliseconds elapsed since 1 January 1970)
```js
var d = new Date( "Mon, 18 Aug 2014 08:53:06 CDT" );

+d; // 1408369986000
```
- most common usage of this idiom is to get the current now moment as a timestamp, such as:
```js
var timestamp = +new Date();
```
- getting the timestamp is also possible in more explicit ways using `getTime()` on a `Date` object or ES5's `Date.now()`

######`~` Operator
- `-1` is a "sentinel value" which basically means it has an arbitrary semantic meaning
- JS's `indexOf(..)` operation for example returns `-1` if a substring is not present in the specified string
- using `~` with `indexOf()` "coerces" (actually transforms) the value to be appropriately `boolean`-coercible
  - for the "failure" case of `-1` we get the falsy `0` by prepending it with `~`
  - **Note:** pseudo algorithm for `~` is `-(x+1)`

####Explicitly: Parsing Numeric Strings
- parsing a numeric value out of a string is *tolerant* of nun-numeric characters
  - it just stops when a non numeric value is encountered whereas coercion is *not tolerant* and gives `NaN`
- parsing and coercion are similar but have different purposes
  - parsing ==> when it is not important what characters might be on the right-hand side of the string
  - coercing ==> when the only acceptable values are numeric and everything else should be rejected
- `parseInt(..)` has a twin `parseFloat(..)` which pulls out a floating point number from a string

####Explicitly: * --> Boolean
- just like with `String(..)` and `Number(..)`, `Boolean(..)` is an explicit way of forcing `ToBoolean` coercion (without `new`!)
- just like the unary `+` operator coerces a value to a number, the unary `!` negate operator explicitly coerces a value to a `boolean` **and** flips it
  - so the most common way to explicitly coerce to `boolean` is to use the `!!` double-negate operator, because the second `!` will flip back to the original
- any `ToBoolean` coercions would happen *implicitly* without the `Boolean(..)` or `!` if used in a boolean context such as an `if` statement

###Implicit Coercion
- refers to type conversion that is hidden or occurs from non-obvious side-effects 

####Implicitly: Strings <--> Numbers
- the `+` algorithm will concatenate if either operand is either already a `string` or if the following steps produce a `string`:
  1. when `+` receives an `object` (including arrays) for either operand it calls the `ToPrimitive` abstract operation on the value
  2. `ToPrimitive` then calls the `DefaultValue` algorithm with a context hint of `number`
  - this operation is identical to how the `ToNumber` operation handles `object`s 
  1. the `valueOf()` operation on the `array` will fail to produce a simple primitive
  2. so it then falls to a `toString()` representation
- otherwise `+` will always perform numeric addidtion
- coercing a `number` to a `string` can simply be done by "adding" the `number` and `""` empty `string`
```js
var a = 45 + "";
```
- implicitly coercing from `string` to `number` can be done with the `-` operator which is defined only for numeric substraction
  - so `"342" - 0` forces the `string` to be coerced to a `number`

####Implicitly: * --> Boolean 
- what sort of expression operations require/force (implicitly) a `boolean` coercion?
  - the test expression in an `if (..)` statement
  - the test expression (second clause) in a `for ( .. ; .. ; ..)` header
  - the test expression in `while (..)` and `do..while(..)` loops 
  - the test expression (first clause) in `? :` ternary expressions
  - the left-hand operand (which serves as a test expression) to the `||`and '&&' operators
- any value used in these contexts that is not already a `boolean` will be implicitly coerced to a `boolean` using the rules of the `ToBoolean` abstract operation

####Operators `||` and `&&`
- the value produced by a && or || operator is not necessarily of type Boolean 
  - the value produced will always be the value of one of the two operand expressions
- both `||` and `&&` perform a `boolean` test on the **first operand** 
  - if the operand is not already `boolean` a normal `ToBoolean` coercion occurs, so that the test can perform
  - for the `||` operator if the test is `true`, the `||` expression results in the value of the *first operand*, if the test ist `false` the expression results in the value of the *second operand*
  - for the `&&` if the test is `true`, the `&&` expression results in the value of the *second operand*, if the test is `false` the expression result in the value of the *first operand*
- the result of a `||` or `&&` expression is always the underlying value of one of the operands and not the coerced result of the test (boolean)
- common and helpful usage of this behavior (skips all falsy values tho!!):
```js
function foo(a,b) {
    a = a || "hello";
    b = b || "world";

    console.log( a + " " + b );
}

foo();                  // "hello world"
foo( "yeah", "yeah!" ); // "yeah yeah!"
```
- the `a = a || "hello"` idiom acts to test a and if it has no value (or only an undesired falsy value), provides a backup default value (`"hello"`)
- the `&&` operator "selects" the second operand only if the first operand tests as truthy, thus allowing a less common idiom called the "guard operator" (short circuited)
```js
function foo() {
    console.log( a );
}
var a = 42;
a && foo(); // 42
```
- `foo` gets called only because `a` tests as truthy
- if that test failed the expression would just silently stop (short circuit) and never call `foo`
```js
var a = 42;
var b = null;
var c = "foo";

if (a && (b || c)) {
    console.log( "yep" );
}
```
- the `a && (b || c)` expression *actually* results in `"foo"` not in `true`
  - the `if` statement *then* forces the `"foo"` value to coerce to a `boolean`

####Symbol Coercion
- *explicit* coercion of a `symbol` to a `string` is allowed, but *implicit* coercion of the same is disallowed (throws an error)
```js
var s1 = Symbol( "cool" );
String( s1 );                   // "Symbol(cool)"

var s2 = Symbol( "not cool" );
s2 + ""; 
```
- `symbol` values cannot coerce to a `number` at all (throws error either way)
- `symbol` values can bot explicitly and implicitly coercte to `boolean`s (always `true`)

###Loose Equals vs. Strict Equals
- `==` allows coercion in the equality comparison and `===` disallows coercion

####Abstract Equality (`==`)
- the `==` operator's behavior is defined as "The Abstract Equality Comparison Algorithm"
- if two values being compared are of the same type, they are compared via Identity as expected ==> `42` is only equal to `42` and `"abc"` only to `"abc"`
  - exceptions: `NaN` is never equal to itself, `+0` and `-0` are equal
- `objects` (including arrays and functions) are only equal if both are references to *the exact same value* (no coerion occurs here)
  - **Note:** the strict `===` equality comparison **behaves identically** in the case where two `object`s are compared
- if `==` is used to compare values of different types one or both of the values will need to be implicitly coerced
  - this coercion happens so that both values eventually end up as the same type, which can then directly be compared using simple value Identity

#####Comparing: `string`s to `number`s
- when comparing `x` to `y`:
  - if type of x is `number` and type of y is `string`:
    - y gets coerced to a number
  - if type of x is `string` and type of y is `number`:
    - x gets coerced to a number

#####Comparing: anything to `boolean`
```js
var a = true;
var b = "42";
a == b; // false
```
- even though `a` is a truthy value it is not loose equal to `true`
- if type of x is boolean:
  - x gets coerced to a number
- if type of y is boolean:
  - y gets coerced to a number
- in the example above x is boolean so `ToNumber(x)` is performed which coerces `true` to `1` ==> now `1 == "42"` is evaluated which is coerced to `1 == 42` resulting in `false`
- `ToBoolean` is not even involved here, so the truthiness of `"42"` is irrelevant to the `==` operation

#####Comparing: `null`s to `undefined`s
- if x is null and y is undefined ==> return true
- if x is undefined and y is null ==> return true
- `null` and `undefined` when loose compared coerce to each other (as well as themselves) and no other values
- the coercion is safe and predictable

#####Comparing: `object`s to non-`object`s
- if an `object`/`function`/`array` is compared to a scalar primitive (string, number, boolean)
  - if type of x is either string or number and type of y is object:
    - `ToPrimitive` is performed on y
  - if type of x is object and type of y is either string or number:
    - `ToPrimitive` is performed on x
  - if either type is boolean ==> see above (boolean coerced to a number)

####Edge Cases
- [a few unlikely example cases](https://github.com/getify/You-Dont-Know-JS/blob/master/types%20%26%20grammar/ch4.md#edge-cases)

###Abstract Relational Comparison
- [see](https://github.com/getify/You-Dont-Know-JS/blob/master/types%20%26%20grammar/ch4.md#abstract-relational-comparison)

##Grammar
- the grammar for JavaScript is a structured way to describe how the syntax (operators, keywords, etc.) fits together into well-formed, valid programs

###Statements & Expressions
- terminology borrowed from the English language:
  - a "sentence"(vollständiger Satz mit Prädikat, Subjekt etc.) is one complete formation of words
    - it is compromised of one or more "phrases"(Ausdruck, Satzteil)
      - a phrase itself can be made up of smaller phrases
      - some phrases are incomplete and dont accomplish much by themselves, but others can stand on their own
    - phrases can be connected with punctuation marks or conjunction words ("and", "or", etc.)
- so it goes for JS grammar:
  - statements are sentences
  - expressions are phrases
  - operators are conjunctions/punctuation
- every expression in JS can be evaluated to a single, specific value result:
```js
var a = 3 * 6;
var b = a;
b;
```
- `3 * 6` is an expression (evaluates to 18)
- `a` on the second line is also an expression, as is `b` on the third
- the `a` and `b` expressions both evaluate to the values stored in those variables (18)
- each of the three lines is a statement containing expressions
  - `var a = 3 * 6` and `var b = a` are called *declaration statements* because they each declare a variable (the value assignments are optional)
  - the `a = 3 * 6` and `b = a` assignments (minus the `var`s) are called *assignment expressions*
- the third line contains just the expression `b` but is also a statement all by itself
  - this is generally called an *expressions statement*

####Statement Completion Values
- statements all have completion values
- obvious way to the this value is to type the statement in the browsers console, because the console reports the completion value of the most recent statement executed
- for example `var a = 18`
  - the assignment expression `a = 18` results in the assigned value (18) 
  - but the `var` statement itself results in `undefined` because var statements are defined that way in the JS specification
- why could it be useful to capture the completion value?
  - the general idea is to be able to treat statements as expressions so they can show up in other statements (without wrapping them in a function and explicitly returning them)
- any regular `{ .. }` block has a completion value of its last contained statement/expression
```js
var b;
if (true) {
  b = 4 + 38;
}
```
- this typed into a console would report `42` since 42 is the completion value of the `if` block which took on the completion value of its last assignment expression statement (`b = ..`)
  - the completion value of a block is like an *implicit return* of the last statement value in the block
- for now statement completion values are trivia but they are probably taking on more as JS evolves (ES7 "do expression" proposal)

####Expression Side Effects
```js
var a = 42;
var b = a++;
```
- the expression `a++` **first** returns the current value of `a` which is 42 (and then gets assigned to b) and **next** it changes the value of `a` itself to 43
  - the `++` and the `--` operator are both unary operators which can be used in either a postfix ("after") position or prefix ("before") position
```js
var a = 42;
var b = 42;

a++;    // 42
a;      // 43

++b;    // 43
b;      // 43
```
- when `++` is used in the prefix position, its side effect (incrementing b) happens *before* the value is returned from the expression, rather *after* as with `a**`
- the `,` statement-series comma operator allows to string together multiple standalone expression statements into a single statement:
```js
var a = 42, b;
b = ( a++, a );

a;  // 43
b;  // 43
```
- the expressions `a++, a` means that the second `a` statement expression gets evaluated *after* the *side effects* of the first `a++` statement expression took action, which results in `43` getting returned to be assigned to `b`
- another side-effecting operator is `delete` (removes a property from an object or a slot from an array)
```js
var obj = {
      a: 42
};
obj.a;          // 42
delete obj.a;   // true
obj.a;          // undefined
}
```
- the result value of the delete operator is true if the requested operation is valid/allowable or false otherwise
  - but the side effect of the operator is that it removes the property (or array entry)
- another non-obvious side effecting operator is `=`
```js
var a;
a = 42; // 42
a; // 42
```
- if examined, the result value of the `a = 42` statement, it's the value that was just assigned (42), so the assignment of that same value into `a` is essentially a side effect
  - **Note:** same reasoning about side effects goes for the compound-assignment operators like `+=`, `-=`, etc
    - for example, `a = b += 2` is processed first as `b += 2` (which is `b = b + 2`), and the result of that `=` assignment is then assigned to `a`
- this behavior, that an assignment expression (or statement) results in the assigned value is primarily useful for chained assignments
```js
var a, b, c;
a = b = c = 42;
```
- `c = 42` is evaluated to `42` (with the side effect of assigning `42` to `c`)
- then `b = 42` is evaluated to `42` (with the side effect of assigning `42` to `b`)
- finally `a = 42` is evaluated (with the side effect of assigning `42` to `a`)
  - **Note:** that `var a = b = 34` would not declare `b` directly so it has to be declared in the scope somewhere before or else a global variable `b` is created (or error in strict mode)

####Contextual Rules
- there are places in the JS grammar rules where the same syntax means different things depending ow where/how it's used

##### { .. } Curly Braces
- the context where `{ .. }` are used determines what they mean, which illustrates the difference between syntax and grammar

######Object Literals
- [see](https://github.com/getify/You-Dont-Know-JS/blob/master/types%20%26%20grammar/ch5.md#object-literals)

######Labels
- JSON-P makes JSON into valid JS grammar

######Object Destructuring
- since ES6 another place where `{ .. }` can show up is with "destructuring assignments" (specifically object destructuring)
```js
function getData() {
    // ..
    return {
        a: 42,
        b: "foo"
    };
}
var { a, b } = getData();
console.log( a, b ); // 42 "foo"
```
- `var { a, b } = ..` is a form of destructuring assignment, which is roughly equivalent to:
```js
var res = getData();
var a = res.a;
var b = res.b;
```
- **Note:** `{ a, b }` is actually ES6 destructuring shorthand for `{ a: a, b: b }` 
- Object destructuring can also be used for named function arguments (nice for implicit object property assignment)
```js
function foo({ a, b, c }) {
    // no need for:
    // var a = obj.a, b = obj.b, c = obj.c
    console.log( a, b, c );
}

foo( {
    c: [1,2,3],
    a: 42,
    b: "foo"
} );    // 42 "foo" [1, 2, 3]
```

######else if and Optional Blocks
- JS does not have an `esle if` clause
- the hidden characteristic is that `if` and `else` statements are allowed to omit `{ }` around their attached block if they only contain a single statement
```js
if (a) doSomething( a );
```
- the same grammar rule applies to the `else` clause so the `esle if` form is actually parsed as:
```js
if (a) {
    // ..
}
else {
    if (b) {
        // ..
    }
    else {
        // ..
    }
}
```
- the `if (b) { .. } else { .. }` is a single statement that follows the `else` so the the surrounding `{ }` is optional

###Operator Precedence
- the `-` operator has a lower precedence that the `=` operator, in fact `,` as a statement-series operator has the lowest precedence, meaning every other operator will bind more tightly
- the `&&` operator has higher precedence than `=` that's why
```js
if (str && (matches = str.match( /[aeiou]/g ))) { // ..  }
```
requires `( )` around the assignment, because without them the expression would be treated as `(str && matches) = str.match..`
  - `str && matches` is not going to be a variable but instead a value (in this case `undefined`) so it can't be the left-hand side of an `=` (`str.match..`) assignment (think `34 = arr[0]`)
- the `&&` operator is evaluated first and then `||`

####Short Circuited
- for both `&&` and `||` operators, the right-hand operand will **not be evaluated** if the left-hand operand is sufficient to determine the outcome of the operation:
  - `a && b`: `b` is not evaluated if `a` is falsy because the outcome is already certain so there is no point in checking `b`
  - `a || b`: if `a` is truthy the result is already certain so there is no reason to check `b`
- short circuiting can be very useful and can be used as sort of a guard
```js
function doSomething(opts) {
    if (opts && opts.cool) {
        // ..
    }
}
```
- if `opts` is unset (or is not an object), `opts.cool` would throw an error, but because of short circuiting `opts.cool` won't even be evaluated if the `opts` test fails
- similarly `||` short circuiting can be used
```js
function doSomething(opts) {
    if (opts.cache || primeCache()) {
        // ..
    }
}
```
- if `opts.cache` is already present, the `primeCache()` isn't called, thus avoiding potentially unnecessary work

####Tighter Binding
```js
a && b || c ? c || b ? a : c && b : a
```
- is that treated more like this:
```js
a && b || (c ? c || (b ? a : c) && b : a)
```
- or more like this?
```js
(a && b || c) ? (c || b) ? a : (c && b) : a
```
- the correct answer is the second one, because `&&` is more precedent than `||` and `||` is more precedent than `? : `
- so the expression `(a && b || c)` is evaluated *first* before the `? : ` participates
- another way to describe this that `&&` and `||` "bind more tightly" than ` ? : `

####Associativity
- what about multiple operators of the same precedence, do they always process left-to-right or right-to-left?
- in general operators are either *left-associative* or *right-associative*, referring to whether **grouping happens from the left or from the right**
  - **Note:** Associativity is *not* the same as left-to-right or right-to-left processing
- why does it matter whether processing is left-to-right or right-to-left?
  - because expression can have side effects, for example:
  ```js
  var a = foo() && bar();
  ```
  - `foo()` is evaluated first and then possibly `bar()` (depending on the result of the `foo()` expression) and that could result in different a behavior than if `bar()` was called before foo
  - but this example just shows left-to-right processing (the default behavior in JS) and it has nothing to do with associativity of `&&` because there is only one `&&` and no relevant grouping
- with an expression like `a && b && c` grouping will happen implicitly as `(a && b) && c` because `&&` (and `||`) is left-associative
- the ternary operator ` ? : ` is right-associative
- another example of right-associativity (grouping) is the `=` operator
```js
var a, b, c;
a = b = c = 42;
```
- the `c = 42` assignment is processed first, then `b = ..` and finally `a = ..` because of the right-associativity which actually treats statements like this as `a = (b = (c = 42))`
- a complex assignment expression:
```js
var a = 42;
var b = "foo";
var c = false;

var d = a && b || c ? c || b ? a : c && b : a;

d;      // 42
```
- broke down into its grouping behavior:
```js
((a && b) || c) ? ((c || b) ? a : (c && b)) : a
```
- or indented:
```js
(
  (a && b)
    ||
  c
)
  ?
(
  (c || b)
    ?
  a
    :
  (c && b)
)
  :
a
```
- step by step solution:
1. (a && b) is "foo".
2. "foo" || c is "foo".
3. for the first ? test, "foo" is truthy.
4. (c || b) is "foo".
5. for the second ? test, "foo" is truthy.
6. a is 42
- ==> the answer is `42`
- use operator precedence/associativity where it leads to cleaner code, but use `( )` manual grouping in places where it helps create clarity and reduce confusion

###Automatic Semicolons
- ASI (Automatic Semicolon Insertion) is when JS assumes a `;` in certain places even if there isn't one there
  - ASI allows JS to be tolerant where `;` are'nt commonly thought to be necessary
  - ASI will only take effect at a line break, semicolons are not inserted in the middle of a line
- if the JS parser parses a line where a parser error would occur (a missing but expected `;`) and it can reasonably insert one, it does so
  - reasonable ==> only if there's nothing but whitespace and/or comments between the end of some statement and that line's newline/line break
- [Error Correction](https://github.com/getify/You-Dont-Know-JS/blob/master/types%20%26%20grammar/ch5.md#error-correction)

[###Errors](https://github.com/getify/You-Dont-Know-JS/blob/master/types%20%26%20grammar/ch5.md#errors)

###`try..finally`
- `try` requires either `catch` or `finally` (or both)
- the code in the `finally` clause will *always* run and it always runs right after the `try` (and `catch` if present) finish, before any other code runs
- `finally` behaves kind of like an callback function that will always be called no matter what
```js
function foo() {
    try {
        return 42;
    }
    finally {
        console.log( "Hello" );
    }
    console.log( "never runs" );
}
console.log( foo() );
// Hello
// 42
```
- the `return 42` runs right away which sets up the completion value from the `foo()` call
- this action completes the `try` clause and the `finally` clause immediately runs next
- only then is the `foo()` function complete so that it's completion value is returned back (for the console.log to use)
- the same happens if there is a `throw` inside the `try` block
- if an exception is thrown  inside a `finally` clause, it will override as the primary completion of that function
  - if a previous `return` in the `try` block had set a completion value for the function, that value will be abandoned

[###switch](https://github.com/getify/You-Dont-Know-JS/blob/master/types%20%26%20grammar/ch5.md#switch)
