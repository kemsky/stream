# stream
Actionscript collection library

Basically it is Array wrapper that adds many useful methods and properties (filter, iterate, map, fold, flatMap, first, last, empty etc.).

Inspired by underscore.js and other other libraries.


## Create
Create Stream examples:
```as3
//create empty Stream
//$ - is provided global function
var s:Stream = $(); 
var s:Stream = new Stream();

//create Stream from arguments, array or ArrayCollection
var s:Stream = $(1, 2 , 3);
var s:Stream = $([1, 2, 3]);
var s:Stream = $(new ArrayCollection([1, 2, 3]));

trace(s.join(","));
//prints 1, 2, 3
```

## Iterate
Stream extends Proxy class and provides the same iteration capabilities as standard Array:
```as3
var s:Stream = $(1, 2, 3);
for each (var item:* in s)
{
   trace(item);
}

for (var i:int = 0; i < s.length; i++)
{
   trace(s[i]);
}

//prints 1, 2, 3
```
