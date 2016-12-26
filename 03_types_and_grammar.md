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
