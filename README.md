# stream [![Build Status](https://api.travis-ci.org/kemsky/stream.svg)](https://travis-ci.org/kemsky/stream)
###ActionScript Modern collection library

Basically it is Array wrapper that adds many useful methods and properties (filter, iterate, map, fold, flatMap, first, second ...  , last, empty etc.).

Inspired by Javascript and Ruby arrays and Scala collections. 

Travis CI integration, 100% code coverage, automated artifact uploading.

See [latest release](http://kemsky.github.io/stream/coverage/).

## Create
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

## Array methods
Stream has all methods(every, forEach, map, some, slice, splice, etc.) that standard Array has:
```as3
var s:Stream = $(1, 2, 3);
s.forEach(function(item:Number):void
{
    trace(item);
});

//prints 1, 2, 3
```
Notice that callback does not have `index:uint` and `array:Array` parameters - 
it is the only difference between Array and Stream APIs.

## foldLeft, foldRight methods

Javascript array has `reduce` method which is similar.
```as3
var sum2:Number = $(0, 1, 2, 3, 4).foldRight(function (prev:Number, current:Number):Number
{
   return prev + current;
}, 10);
trace(sum2);
//prints 20
```

## flatMap
```as3
var s:Stream = new Stream([1, 2, 3], $(4, 5, 6), new ArrayCollection([7, 8, 9]));
var mapped:Stream = s.flatMap(function(item:*):*
{
   //this is nop callback, used just for example
   //you can use short form: s.flatten();
   return item;
});
trace(mapped);
//prints 1, 2, 3, 4, 5, 6, 7, 8, 9
```

## Various filter methods

```as3
public class Item
{
  public var name:String;
  public var price:Number;
}

var item1:Item = new Item("1", 1);
var item2:Item = new Item("2", 2);
var s:Stream = $(item1, item2);

// 1. using custom callback
var result:Stream = s.filter(function(item:Item):Boolean{
   return item.price > 1;
});

// 2. using provided global functions(can compare Boolean, Number, Date, XML, String types)
var result:Stream = s.filter(gt(prop(_, "price"), 1));

// 3. using Proxy magick and global functions
var result:Stream = s.price(gt(_, 1)); 

//all three provide identical results
```

## E4X descendant accessor operator `..`

```as3
var item1:Item = new Item("car", 1);
var item2:Item = new Item("truck", 2);
var s:Stream = $(item1, item2);

var prices:Stream = s..price;

trace(prices);
//prints 1,2
```

## Utility methods
Stream can be converted to Array, ArrayCollection, ArrayList, Object, Dictionary:
```as3
var item1:Item = new Item("1", 1);
var item2:Item = new Item("2", 2);
var s:Stream = $(item1, item2);

var d:Dictionary = s.dictionary("name");

trace(d["1"], item1);
//prints first item

trace(s.second);
//prints second item

trace(s.unique);
//prints true

trace(s.contains(item1));
//prints true

trace(s.count(function(item:Item):Boolean
{
   return item.price > 1;
}));
//prints 1
```

And many other methods: `group`,`partition`,`fill`,`find`,`findIndex`, `drop`, `zip`, `skip` etc. 

## Performance

Stream is about 10x slower when accessed by index (`[index]`) and it seems to be Proxy overhead.
If you need better performance (3x slower than Array) use methods to access stream items: `getItem(index:int):*` and `setItem(index:int, value:*):void`.

## Build

You can build library using **Intelij Idea** or **Apache Maven**.
* Compile `mvn compile`
* Run tests `mvn test -DflashPlayer.command="/Applications/Flash Player.app/Contents/MacOS/Flash Player Debugger"`
* Generate ASDoc(not yet complete): `mvn flexmojos:asdoc`
