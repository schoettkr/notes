#Async & Performance

##Asynchrony: Now & Later

###Event Loop
```js
// ajax(..) is some arbitrary Ajax function given by a library
var data = ajax( "http://some.url.1" );

console.log( data );
// undefined
// Oops! `data` generally won't have the Ajax results
```
- Ajax requests dont complete synchronously, which means the `ajax(..)` function does not yet have any value to return back to be assigned to the `data` variable
- if `ajax(..)` *could* block until the response came back, the `data = ..` assignment would work fine
  - **Note:** it is possible to make synchronous Ajax requests, but it should be avoided at all costs, because it locks the browser UI and prevents any user interaction
- the simplest way (not best) way of "waiting" until `ajax(..)` finished is to use a function, commonly called a callback function
```js
// ajax(..) is some arbitrary Ajax function given by a library
ajax( "http://some.url.1", function myCallbackFunction(data){

    console.log( data ); // Yay, I gots me some `data`!

} );
```
- another (also not the best) way of "waiting" is setting a timer
```js
// ajax(..) is some arbitrary Ajax function given by a library
var data = ajax( "http://some.url.1" );
function logData() {
  console.log( data );
}
setTimeout( logData, 1000);
```

- JS *hosting environments* (browser, server etc.) have a mechanism that handles executing multiple chunks of a program *over time*, at each moment invoking the JS engine, called the "event loop"
  - the JS engine has no sense of *time*, but has instead been an on-demand execution environment for any arbitrary snippet of JS
  - it is the surrounding environment that *sheduled* "events" (JS code executions)
- so when a JS program makes an Ajax request to fetch some data, you set up the "response" code in a function (commonly called a "callback") and the JS engine tells the hosting environment "Hey, I'm going to suspend execution for now, but whenever you finish with that network request, and you have some data, please call this function *back*"
- the browser is then set up to listen for the response and when it has something, it shedules the callback function to be executed by **inserting it into the *event loop**
- vastly simplified pseudocode to illustrate the concept of the event loop:
```js
// `eventLoop` is an array that acts as a queue (first-in, first-out)
var eventLoop = [ ];
var event;

// keep going "forever"
while (true) {
    // perform a "tick"
    if (eventLoop.length > 0) {
        // get the next event in the queue
        event = eventLoop.shift();

        // now, execute the next event
        try {
            event();
        }
        catch (err) {
            reportError(err);
        }
    }
}
```
- there's a constantly running loop and each iteration of the loop is called a "tick"
- for each tick, if an event is waiting in the queue, it's taken off and executed
  - these events are the function callbacks
- **Note:** `setTimeout( .. )` doesn't put a callback in the event loop queue, it instead sets up a timer and when the timer expires, the hosting environment places the callback into the event loop, so that some future tick will pick it up and execute it
  - if there is already 20 items in the event loop, the callback waits (it gets behind all the others)
    - this explains why `setTimeout( .. )` timers may not fire with perfect temporal accuracy (it is guaranteed that the callback won't fire *before* the specified timer interval, but it can happen after that time, depending on the event queue)
- in other words a programm is broken up into lots of small chunks, which happen one after the other in the event loop queue

###Parallel Threading
- it is very common to conflate the terms "async" and "parallel" but they are quite different
- "async" is about the gap between *now* and *later*
- "parallel" is about things being able to occur simultaneously
- most common tools for parallel computing are processes and threads
  - they execute independently and may execute simultaneously
  - but multiple threads can share the memory of a single process
  - in contrast an event loop breaks the work into tasks and executes them in serial, disallowing parallel access and changes to shared memory
- threaded programming is very tricky because if interruption/interleaving are not prevented, nondeterministic behavior might occur
- JS never shares data across threads which means *that* level of nondeterminism isn't a concern but that doesn't mean JS is always deterministic

####Run-to-Completion
- because JS is single-threading code inside `foo()` (and `bar()`) is atomic, which means that once `foo()` starts running, the entirety of its code will be finished before any of the code in `bar()` can run (or vica versa)
  - this is called "**run-to-completion**"

###Concurrency
- Concurrency is when two or more "processes" are executing simultaneously over the same period
  - regardless of whether their individual operations happen *in parallel* (at the same instant on seperate processos) or not
  - "process" not as in the operating system-level process but more like virtual processes/tasks that represent logically connected series of opertions
- example of a onscroll event and an ajax response visualized in the event loop queue
```js
onscroll, request 1   <--- Process 1 starts
onscroll, request 2
response 1            <--- Process 2 starts
onscroll, request 3
response 2
response 3
onscroll, request 4
onscroll, request 5
onscroll, request 6
response 4
onscroll, request 7   <--- Process 1 finishes
response 6
response 5
response 7            <--- Process 2 finishes
```
- Process 1 & 2 run concurrently (taks-level parallel) but their individual events run sequentially on the event loop queue
- the single-threaded event loop is just one expression of concurrency

#####Noninteracting
- if two or more processes don't interact with each other (are unrelated) nondeterminism is absolutely fine

####Interaction
- more commonly concurrent processes will interact with each other (e.g indirectly through scope or the DOM etc)
  - necessary to coordinate these interactions to prevent race conditions (result of programm depending on timing/sequence of operations)
```js
var res = [];

function response(data) {
    res.push( data );
}
// ajax(..) is some arbitrary Ajax function given by a library
ajax( "http://some.url.1", response );
ajax( "http://some.url.2", response );
```
- the concurrent "processes" are the two `response()` calls that will be made to handle the Ajax responses
  - they can happen in either first order
- assuming the expected behavior is that res[0] has the results of the "http://some.url.1" call, and res[1] has the results of the "http://some.url.2" call
- sometimes that will be the case, but sometimes they'll be flipped, depending on which call finishes first
  - there's a pretty good likelihood that this nondeterminism is a "race condition" bug
- don't assume one respond is "always" much slower than another by the virtue of what task they're doing
  -  there is no real guarantee of what order the responses will have
- to prevent such race condition(nondeterminism), coordinate the ordering interaction
```js
var res = [];
function response(data) {
    if (data.url == "http://some.url.1") {
        res[0] = data;
    }
    else if (data.url == "http://some.url.2") {
        res[1] = data;
    }
}
// ajax(..) is some arbitrary Ajax function given by a library
ajax( "http://some.url.1", response );
ajax( "http://some.url.2", response );
```

####Cooperation
- [see](https://github.com/getify/You-Dont-Know-JS/blob/master/async%20%26%20performance/ch1.md#cooperation)

###Jobs
- ES6 introduced a new concept which is layered on top of the event loop queue- the "Job queue"
- the job queue is a queue hanging-off the end of every tick in the event loop queue
  - certain async-implied actions that may occur during a tick of the event loop won't cause a whole new event to be added to the event loop queue but instead will add an item (aka job) to the end of the current tick's job queue
- a job can cause more jobs to be added to the end of the same queue
- jobs are a bit like `setTimeout(.., 0)` but implemented in a way to have much more well-defined and guaranteed ordering ==> **later but as soon as possible**
- imaginary example with an API for sheduling jobs called `schedule( .. )`
```js
console.log( "A" );

setTimeout( function(){
    console.log( "B" );
}, 0 );

// theoretical "Job API"
schedule( function(){
    console.log( "C" );

    schedule( function(){
        console.log( "D" );
    } );
} );
```
- this would print out `A C D B` because jobs happen at the end of the *current* event loop tick , and the timer from `setTimeout` fires to shedule for the *next* event loop tick (if available)

###Statement Ordering
- [see](https://github.com/getify/You-Dont-Know-JS/blob/master/async%20%26%20performance/ch1.md#statement-ordering)

##Callbacks

###Continuation
```js
// A
ajax( "..", function(..){
  // C
})
// B
```
- `A` and `B` represent the first halft of the program (aka the *now*) and `C` marks the second half of the program (aka the *later*)
  - the first half executes right away
  - then there's a "pause" of inderterminate length
  - at some future moment when the ajax call completes the program will *continue* with the second half (`C`)
- the callback function wraps/encapsualtes the *continuation* of the program

###Trying to Save Callbacks
- some API designs provide for split callbacks to save the callback pattern from imploding on itself
  - one for success notification
  - one for the error notification
```js
function success(data) {
    console.log( data );
}
function failure(err) {
    console.error( err );
}
ajax( "http://some.url.1", success, failure );
```
- this split-callback design is what the ES6 Promise API uses

- another common callback pattern is called "error-first style", where the first argument of a single callback is reserved for an error object (if any)
  - on success that argument will be empty/falsy and any following arguments will be the success data
  - on failure the first argument is set/truthy (and usually nothing esle is passed)
```js
function response(err,data) {
    // error?
    if (err) {
        console.error( err );
    }
    // otherwise, assume success
    else {
        console.log( data );
    }
}
ajax( "http://some.url.1", response );
```

- in both callback patterns the majority of trust issued are not resolved like it may appear
  - nothing prevents/filters unwanted repeated invocations
  - more verbose and boilerplate-ish, wichout much reuse
    - typing that out for every single callback
  - nothing to prevent being called "too early" before some critical task is complete
- to prevent the issue of never being called set up a timer that cancels the event after a certain delay:
```js
function timeoutify(fn,delay) {
    var intv = setTimeout( function(){
            intv = null;
            fn( new Error( "Timeout!" ) );
        }, delay )
    ;

    return function() {
        // timeout hasn't happened yet?
        if (intv) {
            clearTimeout( intv );
            fn.apply( this, [ null ].concat( [].slice.call( arguments ) ) );
        }
    };
}
```
- can be used like this
```js
// using "error-first style" callback design
function foo(err,data) {
    if (err) {
        console.error( err );
    }
    else {
        console.log( data );
    }
}
ajax( "http://some.url.1", timeoutify( foo, 500 ) );
```
- **Bottom Line:** callbacks can do pretty much anything, but it is hard work to get them there and this effort is often more than what should be spend on such code reasoning

##Promises
- promises are an easily repeatable mechanism for encapsulating and composing *future* values
  - but of a promise can also be thought of as a flow-control meachnism (for two or more steps in an async task)

###Completion Event
- imagine calling `foo(..)` to perform some task and wanting to do something else as soon as `foo()` finishes to *continue*
- in typical JS waiting for a notification until something finishes is likely done by using an event
  - with callbacks the "notification" would be a callback invoked by some task  `foo(..)`
- with promises the relationship  gets turned around
  - expect to listen for an event from `foo(..)` and when notified proceed
- analogy for a promise:
```js
function foo(x) {
    // start doing something that could take a while

    // make a `listener` event notification
    // capability to return
    return listener;
}

var evt = foo( 42 );

evt.on( "completion", function(){
    // now we can do the next step!
} );

evt.on( "failure", function(err){
    // oops, something went wrong in `foo(..)`
} );
```
- instead of passing the callbacks to `foo(..)`, it returns an event capability (in this example) called `evt`, which recieves the callbacks
  - one lack of callbacks is the inversion of control (see above), thus this inversion of the inversion of control restores the control back to where it should be
- multiple seperate parts of the code can be given the event listening capability and they can be notified independently when `foo(..)` completes, to perform subsequent steps
```js
var evt = foo( 42 );

// let `bar(..)` listen to `foo(..)`'s completion
bar( evt );
// also, let `baz(..)` listen to `foo(..)`'s completion
baz( evt );
```
  - *uninversion of control* enables a nicer *seperation of concerns*
  - `foo` doesn't need to know that `bar` and `baz` exist and that they're waiting for completion
  - also `bar` and `baz` don't need to be involved in how `foo` is called

###Promise "Events"
- in a promised-based approach the previous snippet would have `foo(..)` creating and returning a `Promise` instance and that promise would then be passed to `bar(..)` and `baz(..)`
- promise resolution "events" aren't strictly events (though they behave like events for these purposes) and typically they are not called "completion" or "error"
  - instead `then(..)` is used to register a `"then"` event
    - `then(..)` registers "fullfillment" and/or "rejection" event(s) (though these terms are not seen in the code)
```js
function foo(x) {
    // start doing something that could take a while

    // construct and return a promise
    return new Promise( function(resolve,reject){
        // eventually, call `resolve(..)` or `reject(..)`,
        // which are the resolution callbacks for
        // the promise.
    } );
}

var p = foo( 42 );

bar( p );

baz( p );
```
- the pattern shown with `new Promise (function (..) { .. }` is called the *revealing constructor*
  - the function passsed in is executed immediately
  - the two passed parameters (in this case named `resolve` and `reject`) are the resolution functions for the promise
- interal example of `bar ( .. )`/`baz ( .. )`
```js
function bar(fooPromise) {
    // listen for `foo(..)` to complete
    fooPromise.then(
        function(){
            // resolve
            // `foo(..)` has now finished, so
            // do `bar(..)`'s task
        },
        function(){
            // reject
            // oops, something went wrong in `foo(..)`
        }
    );
}
// ditto for `baz(..)`
```
- another way to approach this is:
```js
function bar() {
    // `foo(..)` has definitely finished, so
    // do `bar(..)`'s task
}

function oopsBar() {
    // oops, something went wrong in `foo(..)`,
    // so `bar(..)` didn't run
}

// ditto for `baz()` and `oopsBaz()`

var p = foo( 42 );

p.then( bar, oopsBar );
p.then( baz, oopsBaz );
```
- **Note:** the last two lines written as `p.then(..).then(..)`, using chaining, would have an entirely different behavior ==> different async pattern
- **Note:** the primary difference in the two above snippets is the error handling
  - in the first approach `bar(..)` and `baz(..)` are called regardless of whether `foo(..)` succeeds or fails and they then handle their own (fallback) logic
  - in the second approach `bar(..)` and `baz(..)` only get called if `foo(..)` succeeds and otherwise `oopsBar(..)`/`oopsBaz(..)` are called
- in both cases the promise that is returned frpm `foo(..)` and then assigned to `p` is used to control what happens next
- the fact that both snippets call `then(..)` against the same promise `p` illustrates that Promises once they are resolved retain their same resolution (fullfillment or rejection)

###Thenable Duck Typing
- it is important to know if some value is a promise or not
  - a non-genuine but promise-like value would still be very important to recognize
- checking for a promise with `XY instanceof Promise` is not totally sufficient
  - Promise values can be recieved from another browser window, which would have its own Promise different from the one in the current window/frame
    - that check would fail to identify the Promise instance
  - a library or framework may choose to vend its own Promises and not use the native ES6 Promise Implementaion
- the way to recognize a Promise or something that behaves like a promise would be to define something called a "thenable"
  - meaning an object or function having `then(..)` method on it
  - any such value is a Promise-conforming thenable
- the general term for "type checks" that make assumptions about a value's "type" based on its shape (what properties are present) is called "duck typing"
  - *"if it looks like a duck and quacks like a duck, it must be a duck"*
- a troubled and ugly way to check for a Thenable
```js
if (
    p !== null &&
    (
        typeof p === "object" ||
        typeof p === "function"
    ) &&
    typeof p.then === "function"
) {
    // assume it's a thenable!
}
else {
    // not a thenable
}
```
- Problems:
  - ugly code
  - if an object/function happens to already had a `then(..)` function on it, it would pass, even if that's not itended
    - could happen without realizing because of prototypal linkage!

###Promise Trust
- a very important characteristic that the Promise pattern establishes is **trust**
- recall the trust issues with callbacks-only coding when a callback is passed to a utility `foo(..)` it might:
  - call the callback too early
  - call the callback too late or never
  - call the callback too few or too many times
  - fail to pass along any necessary environment/parameters
  - swallow any errors/exceptions that may happen
- Promises are designed to provide usefeul, repeatable answers to all these concerns

####Calling Too Early
- this is mainly a concern of whether code can introduce a racing condition, where sometimes a task finishes synchronously and sometimes asynchronously
- promises are immune to this concern, because even an immediately fulfilled Promise (e.g `new Promise(function(resolve){ resolve(42); })`) cannot be *observed* synchronously
- when `then(..)` is called on a Promise, even if that Promise was already solved, the callback provided to `then(..)` will **always** be called asynchronously

####Calling Too Late
- `then(..)` registered callbacks are automatically scheduled when either the `resolve(..)` (first argument to `then(..)`) or `reject(..)` (second, optional argument) functions are called
- those scheduled callbacks will predictably be fired at the next asynchronous moment (tick)
- it is not possible for a synchronous chain of task to "delay" another callback from happeing as expected
  - when a promise is resolved, all `then(..)` registered callbacks on it will be called, in order, immediately at the next asynchronous opportunity
  - nothing that happens inside of one of those callbacks can affect/delay the calling of the other callbacks
    - for example here `"C"` cannot interrupt and precede `"B"` because of how Promises are defined to operate
```js
p.then( function(){
    p.then( function(){
        console.log( "C" );
    } );
    console.log( "A" );
} );
p.then( function(){
    console.log( "B" );
} );
// A B C
```

#####Promise Scheduling Quirks
- there are a lot of nuances of scheduling where the relative ordering between two seperate Promises is not really predictable
```js
var p3 = new Promise( function(resolve,reject){
    resolve( "B" );
} );

var p1 = new Promise( function(resolve,reject){
    resolve( p3 );
} );

var p2 = new Promise( function(resolve,reject){
    resolve( "A" );
} );

p1.then( function(v){
    console.log( v );
} );

p2.then( function(v){
    console.log( v );
} );

// A B  <-- not  B A  as you might expect
```
- `p1` is resolved not with an immediate value, but with another promise `p3` which is itself resolved with the value `"B"`
- the specified behavior *unwraps* `p3` into `p1` asynchronously so `p1`'s callback(s) are *behind* `p2`'s callback(s) in the asynchronous job queue
  - to avoid such nuanced nighmares, code should not rely on anything about the ordering/sheduling of callbacks accross Promises
  - a good practise is to code in a way that the ordering of multiple callbacks does *not* matter

####Never Calling the Callback
- nothing can prevent a Promise from notifying you of its resolution (if it's resolved)
- if both, fullfillment and rejection callbacks are registered for a Promise and the Promise gets resolved, one of the two callbacks will always be called
- Promises provide a higher level abstraction called a "race" for when a Promise itself never gets resolved, preventing a Promise from hanging the program indefinetly
```js
// a utility for timing out a Promise
function timeoutPromise(delay) {
    return new Promise( function(resolve,reject){
        setTimeout( function(){
            reject( "Timeout!" );
        }, delay );
    } );
}

// setup a timeout for `foo()`
Promise.race( [
    foo(),                  // attempt `foo()`
    timeoutPromise( 3000 )  // give it 3 seconds
] )
.then(
    function(){
        // `foo(..)` fulfilled in time!
    },
    function(err){
        // either `foo()` rejected, or it just
        // didn't finish in time, so inspect
        // `err` to know which
    }
);
```

####Calling Too Few(= 0 see "Never Calling the Callback") or Too Many Times
- Promises are defined so they can only be resolved once
- if for some reason the Promise creation code tries to call `resolve(..)` or `reject(..)` multiple times, or tries to call both, the Promise will accept only the first resolution and will silently ignore any subsequent attempts
- because a Promise can only be called once, any `then(..)` registered callbacks will only ever be called once (each)
- of course if the same callback is registered more than once (e.g `p.then(f); p.then(f);`) it will be called as many times as it was registered

####Failing to Pass Along Any Environment/Parameters
- Promises can have, at most, one resolution value (fullfillment or rejection)
- if the Promise is not explicitly resolved with a value either way, the value is `undefined`
  - but whatever the value, it will always be passed to all registered (and appropriate: fullfillment or rejection) callbacks, either now or in the future
- if `resolve(..)` or `reject(..)` is called with multiple parameters, all subsequent parameters beyond the first one will be ignored
  - to pass along multiple values they have to be wrapped in another single value such as an `array` or an `object`
- functions in JS retain their closure of the scope which they're defined in so of course Promises (and callbacks aswell) have access to whatever surrounding state they're provided

####Swallow Any Errors/Exceptions
- if a promise is rejected with a *reason* (aka error message) that value is passed to the rejection callback(s)
- if at any point in the creation of a Promise, or in the observation of its resolution a JS error occurs, such as a `TypeError` or `ReferenceError`, that exception will be caught and it will force the Promise in question to become rejected as well as passing along the error message
```js
var p = new Promise( function(resolve,reject){
    foo.bar();  // `foo` is not defined, so error!
    resolve( 42 );  // never gets here :(
} );

p.then(
    function fulfilled(){
        // never gets here :(
    },
    function rejected(err){
        // `err` will be a `TypeError` exception object
        // from the `foo.bar()` line.
    }
);
```
- Promises even turn JS exceptions into asynchronous behavior, thereby reducing the race condition chances greatly
- even if a Promise is fullfilled, but there's a JS exception error during the observation (in a `then(..)` registered callback), it gets catched
```js
var p = new Promise( function(resolve,reject){
    resolve( 42 );
} );

p.then(
    function fulfilled(msg){
        foo.bar();
        console.log( msg ); // never gets here :(
    },
    function rejected(err){
        // never gets here either :(
    }
);
```
- this might seem like the the exception from `foo.bar()` really did get swallowed (got lost), but in reality something deeper is wrong, which is, that it is not listened for
- the `p.then(..)` call itself returns another promise and it is *that* promise that will be rejected with the `TypeError` exception
  - the error handler defined in the snippet couldn't be called because that would violate the rule that Promises are **immutable** once resolved
  - `p` was already fulfilled with the value `42` so it can't later be changed to a rejection, just because there's an error in observing `p`'s resolution

####Trustable Promise?
