# Programming

## You Don't Know JavaScript
### Scope and Closures
* Compiler Theory
  - JS falls in the category of dynamic/interpredet languages
  - despite this it is a compiled language too although it is not compiled well in advance
  - Compilation falls into three steps:
    1. Tokenizing/Lexing: breaking up strings of characters into meaningful (to the language) chunks called tokens (assigns semantic meaning)
       var a = 2; ==> tokens: var, a, =, 2, ; (plus whitespace if it is meaningful)
    2. Parsing: turning stream(array) of tokens into an AST (**A**bstract **S**yntax **T**ree) to represent grammatical structure of the programm
       var a = 2; Top-level node: VariableDeclaration ,childnode: Identifier => a, childnode AssignmentExpression, childnode of AssignmentExpression: NumericLiteral => 2 
    3. Code-Generation: turning AST into executable Code
  - two types of look-ups: LHS (**L**eft-hand side) and (**R**ight-hand side) ==> 'side' refers to an **assignment operation**
    * LHS: 'who is the target of the assignment ?' a = 2 ==> find a as target for the = 2 assignment operation
      - failing loop up results in a *TypeError* in strict mode and a global var being created when not
    * RHS: 'who is the source(retrieve the value) of the assignment ?' console.log(a) ==> Reference to a to retrieve value
      - failing loop up results in a *ReferenceError*
    * **Note** the term 'side' does *not* refer to any actual side of an '='

* Lexical Scope
  - happens in the first step of compilation
  - lexical scope is scope that is defined at lexing time ==> based on where variables and blocks of scope are authored(written) at write time and thus set in stone (few exceptions) by the time the lexer proccesses(finishes?) the code 
  - scope look-up starts at the innermost scope and works it way up/outward and stops once it finds a match

* Function Scope (vs Block Scope)
  - JS has function-based scope ==> each declaratoin of a function creates a level of scope
  - Variable Shadowing = a variable in a certain scope has the same name(identifier) as a variable declared in an outer scope and thus 'shadows' the outer one
  - scope-based hiding = wrap a function declaration around around some code to tie this code to the scope of the new wrapping function
    - originates from the software design principle "Principle of Least Privilege"(least exposure)
    - expose only what is minimal neccessary and hide everything else
  - Collision Avoidance
    - Global Namespaces: hide internal/private functions and variables by creating a single unique variable declaration (often an object), where all specific exposures of functionality are made as properties of that that object (namespace) (libraries typically do this)
    - Module Management: using any dependency manager results in no libraries ever adding any identifiers to the global scope but are instead required to have their identifier(s) be explicitly exported into another specific scope
    ```js
    function foo() {
      function bar(a) {
        i = 3; // changing the `i` in the enclosing scope's for-loop
        console.log( a + i );
      }

      for (var i=0; i<10; i++) {
        bar( i * 2 ); // oops, infinite loop ahead!
      }
    }

  foo();
  ```
    - The i = 3 assignment inside of bar(..) overwrites, unexpectedly, the i that was declared in foo(..) at the for-loop. In this case, it will result in an infinite loop, because i is set to a fixed value of 3 and that will forever remain < 10. The assignment inside bar(..) needs to declare a local variable to use, regardless of what identifier name is chosen. var i = 3; would fix the problem (and would create the previously mentioned "shadowed variable" declaration for i) 
  - Functions As Scope
    - wrapping everything in a function might not be ideal because the declared identifier name of the function (e.g 'foo') pollutes the enclosing scope (e.g global) and it has to be called by its name to execute the code ==> foo()
    - Better : if the function didnt need a name or the name wouldnt pollute the enclosing scope and get automatically executed
      ```js
      (function foo() {
        ... 
      })();
      ```
    - the function is treated as a function-expression instead of a standard declaration 
      - if 'function' is the **very** first thing in the statement, then its a function declaration; else it's a function expression
    - in this case 'foo' is not bound the enclosing (global) scope, but instead only inside of its own function ==> the identifier 'foo' is only found in the '...' not the outer scope (preventing pollution)
  - Anonymous vs Named Functions
    - **Anonymous Function Expressions** have a few drawbacks
      1. no useful name to display in stack traces, which complicates debugging
      2. without a name problems occur at recursion or unbinding an event handler
      3. a descriptive function name helps in providing more readable Code
    - Solution: **Inline Function Expressions** have no tangible downsides
    ```js
    setTimeout( function timeoutHandler(){ // <-- Look, I have a name!
        console.log( "I waited 1 second!" );
        }, 1000 );
    ```
  - IIFE (Immediately Invoked Function Expressions)
    - having a function expression by wrapping it in a ( ) pair, it can be immediately executed by adding another () at the end
    - IFFE's dont need names but it is considered best practise because of the aforementioned benefits 
    - IIFE's are in fact just function calls thus arguments can be passed
    ```js
    var a = 2;

    (function IIFE( global ){

     var a = 3;
     console.log( a ); // 3
     console.log( global.a ); // 2

     })( window );

     console.log( a ); // 2
    ```
  - Block scope in JS
    - ways to utilize block scope in JS
      1. 'with': the scope created from the object only exists for the lifetime of that *with* statement and not in the enclosing scope; frowned upon
      2. 'try/catch': variable declarations in `catch` are block-scoped to the `catch` block
      3. 'let': introduced by ES6; another way to declare variables; attaches the variable declaration to the scope of whatever block it's contained in; **Note** declarations made with `let` wil not hoist the entire scope of the block they appear in
    - `let` Loops
      - the use of `let` in a for-loop header binds the variable to the for-loop body, in fact it **re-binds it** to each *iteration* of the loop, making sure to re-assign it the value from the end of the previous loop iteration
    - `const`
      - introduced by ES6 `const` creates a block-scoped variable, whose value is fixed(constant); any attempt to change that value results in an error
* Hoisting
  - the *Engine* compiles JS code before it interprets it
  - part of the compilation phase is to find and associate all declarations with their appropriate scopes (Lexical Scope)
  - best way to think about this:
    - all declarations (variables, functions) are processed first, before any code gets executed
    - `var a = 2;` is not one statement but actually two statements ==> `var a;` and `a = 2;` the first statement (the declaration) is processed during compilation and the second statement (assignment) during execution
    - metaphorically functions and variable declarations are "moved" from where they appear to the top of the code (their scope) ==> **Hoisting**
  - function expressions are not hoisted 
    ```js
    foo(); // not ReferenceError, but TypeError!

    var foo = function bar() {
      // ...
    };
    ```
    - the variable identifier `foo` is hoisted and attached to the enclosing scope so `foo()` doesn't fail as a `ReferenceError` but `foo` has no value yet so `foo()` is attempting to invoke the `undefined` value which is an illegal operation ==> `TypeError`
  - Functions First
    - function declarations are hoisted before normal variable declarations
    - multiple/duplicate `var` declarations are ignored; subsequent function declarations *do* override previous ones
    - function declarations in normal blocks are hoisted to the enclosing scope rather than being conditional (in an `if` statement)
      - **Note** this is a subject to be changed in future versions of JS; it is best to avoid declaring functions in blocks alltogether
      ~~test~~ 
