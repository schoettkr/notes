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

###Sequential Brain
