# stream [![Build Status](https://api.travis-ci.org/kemsky/stream.svg)](https://travis-ci.org/kemsky/stream)
###ActionScript collection library - Stream

Basically stream is an array wrapper that adds many useful methods and properties (filter, iterate, map, fold, flatMap, first, second ...  , last, empty etc.).

Inspired by Javascript and Ruby arrays, Scala collections. 

Complete documentation, unit tests with 100% code coverage, Travis CI integration (automatic testing, asdoc and coverage report generation).

See [latest release](https://github.com/kemsky/stream/releases/latest).

## Creating Stream
```as3
var s:Stream = $(1, 2, 3);
var s:Stream = $([1, 2, 3]);
var s:Stream = $(new ArrayCollection([1, 2, 3]));
var s:Stream = $(new ArrayList([1, 2, 3]));
var s:Stream = $(new Stream([1, 2, 3]));

var s:Stream = Stream.from([1, 2, 3]);
var s:Stream = Stream.of(1, 2, 3);

//All expressions are equivalent to:
var s:Stream = new Stream([1, 2, 3])

//Create from iterable object
var obj:Object = {name1: "first", name2: "second"};
var s:Stream = Stream.from(obj);
trace(s);
//prints Stream{Stream{"name1", "first"}, Stream{"name2", "second"}}

//create stream from object property names or property values
var s:Stream = Stream.fromKeys(obj);
trace(s);
//prints Stream{"name1", "name2"}

var s:Stream = Stream.fromValues(obj);
trace(s);
//prints Stream{"first", "second"}

//create from XMLList or XML
var s:Stream = $(<root><item>1</item><item>2</item></root>);
var s:Stream = Stream.from(<root><item>1</item><item>2</item></root>);
trace(s);
//prints Stream{<item>1</item>, <item>2</item>}
```

## Iteration and element access
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
   trace(s.getItem(i));
}
//prints 1, 2, 3

//iterator
var values:Iterator = s.iterator();
while (values.hasNext)
{
   var n:Number = values.next();
   //values.item;
   //values.index;
   //values.remove();
   //values.end();
}
//or use standard for each loop
for each (var item:Number in values)
{
   //values.item;
   //values.index;
   //values.remove();
   //values.end();
}


//set item at index 0
s.setItem(5, 0);
s[0] = 5;
s.first = 5;
//last item also has index -1, item before last -2 and etc. (Ruby-like)
s[-3] = 5;

//remove item from Stream
delete s[0];
s.removeItem(0);
```
*Stream is about 10x slower when accessed by index (`[index]`) and it seems to be Proxy overhead.
If you need better performance (3x slower than Array) use methods to access Stream items: `getItem(index)` and `setItem(value, index)`.*

## Convert Stream to any collection
```as3
var s:Stream = Stream.of(1, 2, 3);

var collection:ArrayCollection = s.collection();
var array:Array = s.array();
var vector:Vector.<Object> = s.vector();
var list:ArrayList = s.list();
```

## Array-like methods
Stream has all methods(every, forEach, map, some, slice, splice, push, pop etc.) that standard Array has:
```as3
var s:Stream = $(1, 2, 3);
s.forEach(function(item:Number):void
{
    trace(item);
});

//prints 1, 2, 3
```
*Notice that callback does not have `index:uint` and `array:Array` parameters -
it is one of the differences between Array and Stream APIs, it is more suitable for functional programming.*

## foldLeft, foldRight methods

Javascript Array has `reduce` method which is quite similar.
```as3
var sum2:Number = $(0, 1, 2, 3, 4).foldRight(function (prev:Number, current:Number):Number
{
   return prev + current;
}, 10);
trace(sum2);
//prints 20
```

## flatMap, flatten
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

## Various filtering methods

```as3
//filter out null, NaN or undefined items
var s:Stream = Stream.of(null, NaN, undefined).compact();
trace(s, s.length);
//prints Stream{}, 0


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
//    supports nested properties i.e. member("prop.prop.prop")
var result:Stream = s.filter(gt(member("price"), 1));

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

## Many other handy methods and properties
Stream can be converted to Object, Dictionary or custom class (using `group` method).
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
//or
trace(s.count(gt(member("price"), 1)));
//prints 1
```

See also: `group`,`partition`,`fill`,`find`,`findIndex`, `drop`, `zip`, `zipWithIndex`, `skip` etc.

## Build

You can build library using **Intelij Idea** or **Apache Maven**.
 - Compile `mvn compile -Dtag.name=<...>`
 - Run tests `mvn test -DflashPlayer.command="<path to flash player projector>"`
 - Generate coverage report `mvn flexmojos:coverage-report -DflashPlayer.command="<path to flash player projector>"`
 - Generate documentation: `mvn flexmojos:asdoc` 
