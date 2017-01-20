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
- Promises dont get rid of callbacks at all, they just change where the callback is passed to; why would this be more trustable than callbacks alone?
- Promises have a solution to this issue included with the ES6 `Promise` Implementaion of `Promise.resolve(..)`
- passing an immediate, non-Promise, non-thenable value to `Promise.resolve(..)` will return a promise that's fulfilled with that value
```js
var p1 = new Promise( function(resolve,reject){
    resolve( 42 );
} );

var p2 = Promise.resolve( 42 );
```
- these two promises above will behabe basically identically
- and passing a genuine Promise to `Promise.resolve(..)` the same promise gets returned:
```js
var p1 = Promise.resolve( 42 );

var p2 = Promise.resolve( p1 );

p1 === p2; // true
```
- passing a non-Promise but thenable value to `Promise.resolve(..)`, it will attempt to unwrap that value until a concrete final non-Promise-like value is extracted
```js
var p = {
    then: function(cb) {
        cb( 42 );
    }
};

// this works OK, but only by good fortune
p
.then(
    function fulfilled(val){
        console.log( val ); // 42
    },
    function rejected(err){
        // never gets here
    }
);
```
- this `p` is thenable, but it's not a genuine Promise
- luckily this is reasonable so the use of `Promise.resolve(..)` wouldn't be so obvious here
```js
var p = {
    then: function(cb,errcb) {
        cb( 42 );
        errcb( "evil laugh" );
    }
};

p
.then(
    function fulfilled(val){
        console.log( val ); // 42
    },
    function rejected(err){
        // oops, shouldn't have run
        console.log( err ); // evil laugh
    }
);
```
- in this case it behaves not so well
- passing either of the above snippets of `p` to `Promise.resolve(..)` though will return a normalized, safe result
```js
Promise.resolve( p )
.then(
    function fulfilled(val){
        console.log( val ); // 42
    },
    function rejected(err){
        // never gets here
    }
);
```
- `Promise.resolve(..)` will accept any thenable and will unwrap it to its non-thenable value and return a **trustable** real, genuine Promise
  - if what is passed in is already a genuine Promise then just this Promise is returned
    - so there is no downside by filtering through `Promise.resolve(..)` to gain trust
- for example calling a `foo(..)` utility and it is not sure whether the return value can be trsted to be a well-behaving Promise, but it is sure that it is at least a thenable
```js
// don't just do this:
foo( 42 )
.then( function(v){
    console.log( v );
} );

// instead, do this:
Promise.resolve( foo( 42 ) )
.then( function(v){
    console.log( v );
} );
```
- `Promise.resolve(..)` will give a trustable Promise wrapper
- another side effect of wrapping `Promise.resolve(..)` around any function's return value (thenable or not) is that it's an easy way to normalize that function call into a well-behaving async task 
  - if foo(42) returns an immediate value sometimes, or a Promise other times, Promise.resolve( foo(42) ) makes sure it's always a Promise result (and avoiding Zalgo makes for much better code)

###Chain Flow
- it's possible to string multiple Promises together to represent a sequence of async steps
  - everytime `then(..)` is called on a Promise, it creates and returns a new Promise, whcih can be *chained*
  - whatever value returned from a `then(..)` call's fullfillment callback (the first parameter) is automatically set as the fullfillment of the *chained* Promise
```js
var p = Promise.resolve( 21 );

var p2 = p.then( function(v){
    console.log( v );   // 21

    // fulfill `p2` with value `42`
    return v * 2;
} );

// chain off `p2`
p2.then( function(v){
    console.log( v );   // 42
} );
```
- by returning `v * 2` (21 * 2) the `p2` promise, that the first `then(..)` call created and returned, is fulfilled
- when `p2`'s `then` call runs, it recieves the fulfillment from the `return v * 2` statement
- of course `p2`  then creates yet another promise, which could have been in stored in a `p3` variable for example

- the steps above (and creating an intermediate var like `p2 p3` everytime) can get a bit annoying so luckily they can be chained together
```js
var p = Promise.resolve( 21 );

p
.then( function(v){
    console.log( v );   // 21

    // fulfill the chained promise with value `42`
    return v * 2;
} )
// here's the chained promise
.then( function(v){
    console.log( v );   // 42
} );
```
- now the first `then(..)` is the first step in an async sequence and the second `then` is the second step
  - this could keep going for as long as needed just by chaining off a previous `then` with each automatically created Promise
- [making a Promise sequence truly async capable at everystep](https://github.com/getify/You-Dont-Know-JS/blob/master/async%20%26%20performance/ch3.md#chain-flow)
  - like in waiting for step 1 in a chain to do(finish) something asynchronous and then start with step 2

####Terminology: Resolve, Fulfill and Reject
- the `Promise(..)` constructor
```js
var p = new Promise( function(X,Y){
    // X() for fulfillment
    // Y() for rejection
} );
```
- the second provided callback `Y` *always* marks the Promise as rejected
  - it's almost always called `reject(..)` because that is what it exactly (and only) does
- the first provided callback `X` is *usually* used to mark the Promise as fulfilled
  - often labeled as `resolve(..)` which is related to "resolution"
  - good, accurate name because if `Promise.resolve(..)` unwraps a recieved thenable to a rejected state, the Promise returned from `Promise.resolve(..)` is in fact in the same rejected state
    - so calling `X` for example `fulfill(..)` wouldn't be accurate because `X` can result in fulfillment or rejection

- the callbacks provided to `then(..)` should be called `fulfilled(..)` and `rejected(..)` because they are unambigous and for the first parameter fulfillment is always the case, as well as it is rejection for the second

###Error Handling
- the common form of error handling, using the synchronous `try..catch` construct unfortunately fails to help in async code patterns:
```js
function foo() {
    setTimeout( function(){
        baz.bar();
    }, 100 );
}

try {
    foo();
    // later throws global error from `baz.bar()`
}
catch (err) {
    // never gets here
}
```

- in callbacks some standards have emerged for error handling, most notably the "error-first callback" style
  - this sort of error handling is technically *async capable* but it doesn't compose well
```js
function foo(cb) {
    setTimeout( function(){
        try {
            var x = baz.bar();
            cb( null, x ); // success!
        }
        catch (err) {
            cb( err );
        }
    }, 100 );
}

foo( function(err,val){
    if (err) {
        console.error( err ); // bummer :(
    }
    else {
        console.log( val );
    }
} );
```
- **Note:** the `try..catch` only works here from the perspective that the `baz.bar()` call will either succeed or fail immediately (synchronously)
  - if `baz.bar()` itself was async, any async errors inside it would not be catchable
- the callback passed to `foo(..)` expects to recieve a signal of an error by the reserverd first parameter `err`
  - if present error/failure is assumed, if not success is assumed

- Promises don't use the popular "error-first callback" design style, instead they use "split callbacks" style (one callback for fulfillment and one for rejection)
```js
var p = Promise.reject( "Oops" );

p.then(
    function fulfilled(){
        // never gets here
    },
    function rejected(err){
        console.log( err ); // "Oops"
    }
);
```
- the nuances of Promise error handling are often a bit more difficult
```js
var p = Promise.resolve( 42 );

p.then(
    function fulfilled(msg){
        // numbers don't have string functions,
        // so will throw an error
        console.log( msg.toLowerCase() );
    },
    function rejected(err){
        // never gets here
    }
);
```
- `msg.toLowerCase` throws an error, but the error handler doesn't get notified because *that* error handler is for the `p` promise which has been already fulfilled with the value `42`
- the `p` promise is immutable so the only promise that can be notified of the error is the one returned from `p.then(..)`, which in this case isn't captured
  - this is why such error handling with Promises is error-prone (errors get swallowed too easy)
- some developers claim that a best practise for Promise chains is to always end the chain with a final `catch(..)` like:
```js
var p = Promise.resolve( 42 );

p.then(
    function fulfilled(msg){
        // numbers don't have string functions,
        // so will throw an error
        console.log( msg.toLowerCase() );
    }
)
.catch( handleErrors );
```
- because there is no rejection handler explicitly defined, the default handler substitutes which simply propagates the error to the next promise in the chain
  - both, errors that come into `p` and errors that happen *after* `p` in its resolution (like `msg.toLowerCase`) will be handed down to the final `handleErrors(..)`
- what happens if `handleErrors(..)` itself has an error in it? There is still yet another uncaptured promise, the one that `catch(..)` returns!
  - `catch` too could fail so it should not be just sticked at the end of that chain
  - the last step in any Promise chain always has the possibility of an uncaught error stuck inside an unobserved Promise

####Uncaught Handling
- [see](https://github.com/getify/You-Dont-Know-JS/blob/master/async%20%26%20performance/ch3.md#uncaught-handling) (no practical information)

####Pit Of Success
- theoretical outline of how Promises *could* be changed to behave someday
- [see](https://github.com/getify/You-Dont-Know-JS/blob/master/async%20%26%20performance/ch3.md#pit-of-success)

###Promise Patterns
- there are lots of variations on asynchronous patterns that can be build on top of Promises
- there two patterns directly coded into the native ES6 Promise Implementaion to simplify the expression of async flow control
  - helps making code more reasonable and maintainable
  - can be used as building blocks of other paterns

####Promise.all([..])
- in any async sequence (Promise chain) only one async task is being coordinate at any given moment, step 2 directly follows step 1 and step 3 strictly follows step
- but what about doing two or ore steps concurrently/parallel?
- in classic programming Terminology a "gate" is a mechanism thats waits on two or more parallel tasks to complete before continuing
  - the order they finish in doesnt matter, just all of them have to comlete for the gate to open and let the flow control through
- in the Promise API this pattern is called `all([..])`
  - the main Promise returned from `Promise.all` will only be fulfilled if and when all its constituent promises are fullfilled, if any of these promises is rejected, the main `Promise.all` promise is immediately rejected discarding all results from the other Promises
- for example making two Ajax requests at the same time and wait for both to finish (regardless of their order) before making a third Ajax request
```js
// `request(..)` is a Promise-aware Ajax utility,
// like we defined earlier in the chapter

var p1 = request( "http://some.url.1/" );
var p2 = request( "http://some.url.2/" );

Promise.all( [p1,p2] )
.then( function(msgs){
    // both `p1` and `p2` fulfill and pass in
    // their messages here
    return request(
        "http://some.url.3/?v=" + msgs.join(",")
    );
} )
.then( function(msg){
    console.log( msg );
} );
```
- `Promise.all([..])` expects a single array as an argument, generally consisting of Promise instances
  - the array can also include thenables or even immediate values, because every value is essentially passed through `Promise.resolve` to make sure it's a genuine promise
    - if the array is empty the main Promise is immediately fulfilled
- the promise returned from  `Promise.all([..])` call will receive a fulfillment message (`msg` in the above snippet) that is an array of all the fulfillment messages from the passed in Promises (in the order they were specified not the fulfillment order)
- always attach a rejection/error handler to every promise, especially to the one that comes back from `Promise.all`

####Promise.race([..])
- not to confuse "race" with as in "racing condition", classically a race in the Promise API is called a "latch"
- only responds to the first Promise that finishes , letting the other Promises fall away
- `Promise.race([ .. ])` also expects a single array argument, containing one or more Promises, thenables, or immediate values
  - obviously the first immediate value listed would win tho
- **Note::** pass an empty array to `Promise.race([])` because, instead of immediately resolving, the main race promise will never resolve
```js
// `request(..)` is a Promise-aware Ajax utility,
// like we defined earlier in the chapter

var p1 = request( "http://some.url.1/" );
var p2 = request( "http://some.url.2/" );

Promise.race( [p1,p2] )
.then( function(msg){
    // either `p1` or `p2` will win the race
    return request(
        "http://some.url.3/?v=" + msg
    );
} )
.then( function(msg){
    console.log( msg );
} );
```
- because only one promise wins, the fulfillment value is a single message (not an array or smth)

####Timeout Race
- how `Promise.race([ .. ])` can be used to expres the "promise timeout" pattern:
```js
// `foo()` is a Promise-aware function

// `timeoutPromise(..)`, defined ealier, returns
// a Promise that rejects after a specified delay

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
- this timeout pattern works well in most cases but there are some nuances to consider (nd they apply to `Promise.all([ .. ])`) too:

####"Finally"
- what happens to the promises discarded/ignored from the behavioral perspective?
  - promises cannot and shouldnt be canceled, s they can only be ignored
- [more](https://github.com/getify/You-Dont-Know-JS/blob/master/async%20%26%20performance/ch3.md#finally)

###Variations on all([..]) and race([..])
- while `race` and `all` are built in to native ES6 Promises, there are several other common patterns that can be built using them 
- `none([..])` is like `all([..])` but fulfillments and rejections are transposed(umgekehrt); all promises need to be rejected and rejections become the fullfillment values(& vica versa)
- `any([..])` is like `all([..])` but ignores any rejections so it only need to fulfill one instead of all of them
- `first([..])` ist like a race with `any([..])`, so it ignores any rejections and fulfills s soon as the first Promise fulfills
- `last([..])` is like `first([..])` but only the last fulfillment wins

###Concurrent Iterations
- to iterate over fundamentally asynchronous tasks use/define/build aync versions of the usual iterators like `forEach`, `map`, `some` and `every`
- [more](https://github.com/getify/You-Dont-Know-JS/blob/master/async%20%26%20performance/ch3.md#finally)

##Generators
- expressing async flow control in a sequential, synchronous-looking fashion is possible with **generators**
- in the following example `bar()` runs in between `x++` and `console.log(x)` but if it wasn't there the result would be 2 instead of 3
```js
var x = 1;

function foo() {
    x++;
    bar();              // <-- what about this line?
    console.log( "x:", x );
}

function bar() {
    x++;
}

foo();                  // x: 3
```
- but what would happen if `bar()` wasn't present in `foo()` but could still somehow run between `x++` and `console.log(x)`?
```js
var x = 1;

function *foo() { // the '*' is a stylistic preference to mark a generator
    x++;
    yield; // pause!
    console.log( "x:", x );
}

function bar() {
    x++;
}

// construct an iterator `it` to control the generator
var it = foo();

// start `foo()` here!
it.next();
x;                      // 2
bar();
x;                      // 3
it.next();              // x: 3
```
- `yield` suggests a pause point in code
- the `it = foo()` operation does *not* execute the `*foo()` generator, but it constructs an *iterator* that will control its execution
- `it.next()` starts the `*foo()` generator until the `yield` statement, at which point the call finishes and `*foo()` is running & active, but in a paused Statement
- now `bar()` runs and increments `x` by one and then the iterator resumes the `*foo()` generator with the final `it.next()` call and it lets it finish
  - it is not even required for a generator to finish
- so a generator is a special kind of function that can start and stop one or more times

###Input and Output
- a generator function is still a function, so it has some basic tenets that haven't changed
- for example accepting arguments:
```js
function *foo(x,y) {
    return x * y;
}

var it = foo( 6, 7 );

var res = it.next();

res.value;      // 42
```
- `foo(6,7)` just creates an *iterator* object which is assigned to `it` to control the `*foo(..)` generator, but doesn't actually run it yet as it would've been with a "normal" function
- `it.next()` instructs the `*foo()` generator to advance from its current location, stopping either at the next `yield` or at the end of the generator
- the result of that `next(..)` call is an object with a `value` property on it, holding whatever value (if anything) was returned from `*foo(..)`
  - it also has a `.done` property on it which indicates if the generator has finished or is paused

####Iteration Messaging
- `yield` and `next(..)` have some more powerful input/output messaging capability
```js
function *foo(x) {
    var y = x * (yield);
    return y;
}

var it = foo( 6 );

// start `foo(..)`
it.next();

var res = it.next( 7 );

res.value;      // 42
```
1. after calling `it.next()` for the first time, the `var y = x..` statement starts to be processed but then it runs across a `yield` expression
2. at that point it pauses `*foo()` (in the middle of that assignment statement) and requests the calling code to provide a result value for the `yield` expression
3. `it.next(7)` passes the `7` value back in, to *be* that result of the paused `yield` expression
4. at this point the assignment statement essentially is `var y = 6 * 7`
5. now `return y` returns that `42` back as the result of `it.next(7)` call
- **Note:** in general there is going to be one more `next(..)` call than `yield` statements because the first `next(..)` call starts a generator until the first `yield` expression, there is one more `next(..)` call needed to fulfill until the end (or another until `yield`)

- `yield ..` and `next(..)` pair together as a two-way message passing system during the execution of a generator
  - yield can send out messages as a response to a `next` called
  - next can send values to a paused `yiel` expression
```js
function *foo(x) {
    var y = x * (yield "Hello");    // <-- yield a value!
    return y;
}

var it = foo( 6 );

var res = it.next();    // first `next()`, don't pass anything
res.value;              // "Hello"

res = it.next( 7 );     // pass `7` to waiting `yield`
res.value;              // 42
```
- don't pass anything to the first `next(..)` call because only a paused `yield` could accept such a value but at the beginning of the generator when calling `next()` for the first time, there **is no paused `yield`** to accept such a value

####Multiple Iterators
- each time you construct an iterator, implicitly an instance of the generator is constructed, which *that iterator* will control
  - it's possible to have multiple instances of the same generator running at the same time and even interacting, for example:
```js
function *foo() {
    var x = yield 2;
    z++;
    var y = yield (x * z);
    console.log( x, y, z );
}

var z = 1;

var it1 = foo();
var it2 = foo();

var val1 = it1.next().value;            // 2 <-- yield 2
var val2 = it2.next().value;            // 2 <-- yield 2

val1 = it1.next( val2 * 10 ).value;     // 40  <-- x:20,  z:2
val2 = it2.next( val1 * 5 ).value;      // 600 <-- x:200, z:3

it1.next( val2 / 2 );                   // y:300
                                        // 20 300 3
it2.next( val1 / 4 );                   // y:10
                                        // 200 10 3
```
1. Both instances of `*foo()` are started at the same time, and both `next()` calls reveal a `value` of `2` from the `yield 2` statements, respectively.
2. `val2 * 10` is `2 * 10`, which is sent into the first generator instance `it1`, so that `x` gets value `20`. `z` is incremented from `1` to `2`, and then `20 * 2` is `yield`ed out, setting `val1` to `40`.
3. `val1 * 5` is `40 * 5`, which is sent into the second generator instance `it2`, so that `x` gets value `200`. `z` is incremented again, from `2` to `3`, and then `200 * 3` is `yield`ed out, setting `val2` to `600`.
4. `val2 / 2` is `600 / 2`, which is sent into the first generator instance `it1`, so that `y` gets value `300`, then printing out `20 300 3` for its `x y z` values, respectively.
5. `val1 / 4` is `40 / 4`, which is sent into the second generator instance `it2`, so that `y` gets value `10`, then printing out `200 10 3` for its `x y z` values, respectively.

###Generator'ing Values
####Producers and Iterators
- [see](https://github.com/getify/You-Dont-Know-JS/blob/master/async%20%26%20performance/ch4.md#producers-and-iterators)

####Iterables
- [see](https://github.com/getify/You-Dont-Know-JS/blob/master/async%20%26%20performance/ch4.md#iterables)

####Generator Iterator
- [see](https://github.com/getify/You-Dont-Know-JS/blob/master/async%20%26%20performance/ch4.md#generator-iterator)

#####Stopping the Generator
- [see](https://github.com/getify/You-Dont-Know-JS/blob/master/async%20%26%20performance/ch4.md#stopping-the-generator)

###Iterating Generators Asynchronously


###Generators + Promises
- the natural way to get the most out of Promises and generators is **to `yield` a Promise** and wire that Promise to control the generator's *iterator*
```js
function foo(x,y) {
    return request(
        "http://some.url.1/?x=" + x + "&y=" + y
    );
}

function *main() {
    try {
        var text = yield foo( 11, 31 );
        console.log( text );
    }
    catch (err) {
        console.error( err );
    }
}
```
- the most powerful revelation in this refactor is that the inside `*main()` **did not have to change at all**
- inside the generator whatever values are `yield`ed out is just an opaque implementation detail, there is no need to worry about it
- to recieve and wire up the `yield`ed promise so that it resumes the generator upon resolution, some work is still needed
```js
var it = main();

var p = it.next().value;

// wait for the `p` promise to resolve
p.then(
    function(text){
        it.next( text );
    },
    function(err){
        it.throw( err );
    }
);
```
- this takes advantage of the fact the we know that `*main()` only has one Promise-aware step in it
  - but what if we want to be able to Promise-drive a generator no matter how many steps it has?

####Promise-Aware Generator Runner
