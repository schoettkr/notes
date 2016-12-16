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
* Function vs Block Scope

