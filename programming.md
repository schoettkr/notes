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
    - Global Namespaces: hide internal/private functions and variables by creating a single unique variable declaration (often an object), where all specific exposures of functionality are made as properties of that that object (namespace) (libraries typically do this)
    - Module Management: using any dependency manager results in no libraries ever adding any identifiers to the global scope but are instead required to have their identifier(s) be explicitly exported into another specific scope
  - Functions As Scope
    
