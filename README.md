# stream
Actionscript collection library

Basically it is Array wrapper that adds many useful methods and properties (filter, iterate, map, fold, flatMap, first, last, empty etc.).

Inspired by underscore.js and other other libraries.


Simple examples:

```
//create Stream
var s:Stream = $(); //empty
var s:Stream = new Stream(); //empty
var s:Stream = $(1, 2 , 3);
var s:Stream = $([1, 2, 3]);
var s:Stream = $([1, 2, 3]);
```