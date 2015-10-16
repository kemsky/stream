# stream [![Build Status](https://api.travis-ci.org/kemsky/stream.svg)](https://travis-ci.org/kemsky/stream)
###ActionScript collection library - Stream

Basically List is an array wrapper that adds many useful methods and properties (filter, iterate, map, fold, flatMap, first, second ...  , last, empty etc.).

Inspired by Javascript and Ruby arrays, Scala collections. 

Complete documentation, unit tests with 100% code coverage, Travis CI integration (automatic testing, asdoc and coverage report generation).

See [latest release](https://github.com/kemsky/stream/releases/latest).

## Creating List
```as3
var s:List = $(1, 2, 3);
var s:List = $([1, 2, 3]);
var s:List = $(new ArrayCollection([1, 2, 3]));
var s:List = $(new ArrayList([1, 2, 3]));
var s:List = $(new List([1, 2, 3]));

//All expressions are equivalent to:
var s:List = new List([1, 2, 3])
```

## Iteration and element access
List extends Proxy class and provides the same iteration capabilities as standard Array:
```as3
var s:List = $(1, 2, 3);
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

//set item at index 0
s.setItem(0, 5);
s[0] = 5;
s.first = 5;
//last item also has index -1, item before last -2 and etc. (Ruby-like)
s[-3] = 5;

//remove item from List
delete s[0];
```
*List is about 10x slower when accessed by index (`[index]`) and it seems to be Proxy overhead.
If you need better performance (3x slower than Array) use methods to access List items: `getItem(index)` and `setItem(index, value)`.*

## Array-like methods
List has all methods(every, forEach, map, some, slice, splice, push, pop etc.) that standard Array has:
```as3
var s:List = $(1, 2, 3);
s.forEach(function(item:Number):void
{
    trace(item);
});

//prints 1, 2, 3
```
*Notice that callback does not have `index:uint` and `array:Array` parameters -
it is one of the differences between Array and List APIs.*

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
var s:List = new List([1, 2, 3], $(4, 5, 6), new ArrayCollection([7, 8, 9]));
var mapped:List = s.flatMap(function(item:*):*
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
public class Item
{
  public var name:String;
  public var price:Number;
}

var item1:Item = new Item("1", 1);
var item2:Item = new Item("2", 2);
var s:List = $(item1, item2);

// 1. using custom callback
var result:List = s.filter(function(item:Item):Boolean{
   return item.price > 1;
});

// 2. using provided global functions(can compare Boolean, Number, Date, XML, String types)
var result:List = s.filter(gt(prop(_, "price"), 1));

// 3. using Proxy magick and global functions
var result:List = s.price(gt(_, 1)); 

//all three provide identical results
```

## E4X descendant accessor operator `..`

```as3
var item1:Item = new Item("car", 1);
var item2:Item = new Item("truck", 2);
var s:List = $(item1, item2);

var prices:List = s..price;

trace(prices);
//prints 1,2
```

## Many other handy methods and properties
List can be converted to Array, ArrayCollection, ArrayList, Object, Dictionary:
```as3
var item1:Item = new Item("1", 1);
var item2:Item = new Item("2", 2);
var s:List = $(item1, item2);

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

See also: `group`,`partition`,`fill`,`find`,`findIndex`, `drop`, `zip`, `skip` etc.

## Build

You can build library using **Intelij Idea** or **Apache Maven**.
 - Compile `mvn compile`
 - Run tests `mvn test -DflashPlayer.command="<path to flash player projector>"`
 - Generate coverage report `mvn flexmojos:coverage-report -DflashPlayer.command="<path to flash player projector>"`
 - Generate documentation: `mvn flexmojos:asdoc`
