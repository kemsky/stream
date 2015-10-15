package com.kemsky
{
    import com.kemsky.filters._;
    import com.kemsky.filters.defined;
    import com.kemsky.support.*;

    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    import flash.utils.IExternalizable;
    import flash.utils.Proxy;
    import flash.utils.flash_proxy;

    import mx.collections.ArrayCollection;
    import mx.collections.ArrayList;

    use namespace stream_internal;

    /**
     * ActionScript modern collection/list implementation, Array replacement.
     * Internally this is Array wrapper that adds many useful methods and properties:
     * filter, iterate, map, fold, flatMap, first, second ... , last, empty etc.
     * Inspired by Javascript and Ruby arrays and Scala collections.
     */
    [RemoteClass(alias="com.kemsky.Stream")]
    public dynamic class Stream extends Proxy implements IExternalizable
    {
        /**
         * Specifies case-insensitive sorting for the Stream class sorting methods.
         */
        public static const CASEINSENSITIVE:uint = 1;

        /**
         * Specifies descending sorting for the Stream class sorting methods.
         */
        public static const DESCENDING:uint = 2;

        /**
         * Specifies numeric (instead of character-string) sorting for the Stream class sorting methods.
         */
        public static const UNIQUESORT:uint = 4;

        /**
         * Specifies that a sort returns a stream that consists of array indices.
         */
        public static const RETURNINDEXEDARRAY:uint = 8;

        /**
         * Specifies the unique sorting requirement for the Stream class sorting methods.
         */
        public static const NUMERIC:uint = 16;

        /**
         *  The source of data in the stream.
         */
        stream_internal var source:Array;

        /**
         *  Constructor.
         *
         *  <p>Creates a new stream using the specified source array.
         *  If no array is specified an empty array will be used.</p>
         * @example
         * <pre>
         *     var s:Stream = new Stream();
         *     var s:Stream = new Stream([1, 2, 3]);
         * </pre>
         */
        public function Stream(source:Array = null)
        {
            this.source = source == null ? [] : source;
        }

        /**
         * Creates a new stream for all items that are not strictly equal to undefined (item !== <i>undefined</i>).
         * @return A new stream that contains all items from the original stream that are not equal to <i>undefined</i>.
         * @example
         * <pre>
         *     var s:Stream = new Stream();
         *     s[0] = 1;
         *     s[10] = 2;
         *     var c:Stream = s.compact();
         *     trace(c);
         *     //Stream{1, 2}
         * </pre>
         */
        public function compact():Stream
        {
            return filter(defined(_));
        }

        /**
         * Splits current stream into two streams depending on testing callback.
         * @param callback A function to run on each item of the stream: function(item:*):Boolean.
         * @return A new stream containing two streams: the first stream from items with positive test and second with negative.
         * @example
         * <pre>
         *      var s:Stream = $(1, 2, 3);
         *      var groups:Stream = s.partition(function (item:Number):Boolean
         *      {
         *          return item < 3;
         *      }
         *      trace(groups);
         *      //Stream{Stream{1, 2}, Stream{3}}
         * </pre>
         */
        public function partition(callback:Function):Stream
        {
            var first:Stream = new Stream();
            var second:Stream = new Stream();

            for each (var item:* in source)
            {
                if(callback(item))
                {
                    first.push(item);
                }
                else
                {
                    second.push(item);
                }
            }

            return new Stream([first, second]);
        }

        /**
         * Fills current stream with provided value.
         * @param value An item used to fill the stream.
         * @param length An Integer that specifies the how many items to set.
         * @return Current stream.
         * @example
         * <pre>
         *     var s:Stream = $();
         *     s.fill(1, 3);
         *     trace(s);
         *     //Stream{1, 1, 1}
         * </pre>
         */
        public function fill(value:*, length:int = -1):Stream
        {
            var count:uint = length == -1 ? source.length : length;

            for(var i:int = 0; i < count; i++)
            {
                source[i] = value;
            }
            return this;
        }

        /**
         * Creates a new stream of streams created from the items and their corresponding indices.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     var z:Stream = s.zip();
         *     trace(z);
         *     //Stream{Stream{0, 1}, Stream{1, 2}, Stream{2, 3}}
         * </pre>
         * @return A new stream of streams created from the items and their corresponding indices.
         */
        public function zip():Stream
        {
            var result:Array = [];
            result.length = source.length;
            for(var i:int = 0; i < source.length; i++)
            {
                result[i] = new Stream([i, source[i]]);
            }
            return new Stream(result);
        }

        /**
         * Returns an index of the item in the stream, if an item in the stream satisfies the provided testing callback.
         * Otherwise -1 is returned.
         * @param callback The function to run on each item of the stream: function(item:*):Boolean.
         * @param reverse Start search from the end of the stream.
         * @return An index of the item that satisfies provided testing callback; otherwise -1 is returned.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     var index:int = s.findIndex(function(item:Number):Boolean
         *     {
         *        return item > 1;
         *     });
         *     trace(index);
         *     //1
         * </pre>
         */
        public function findIndex(callback:Function, reverse:Boolean = false):int
        {
            if(reverse)
            {
                for(var k:int = source.length - 1; k > 0; k--)
                {
                    if(callback(source[k]))
                    {
                        return k;
                    }
                }
            }
            else
            {
                for(var i:int = 0; i < source.length; i++)
                {
                    if(callback(source[i]))
                    {
                        return i;
                    }
                }
            }

            return -1;
        }

        /**
         * Returns a value in the stream, if an item in the stream satisfies the provided testing callback.
         * Otherwise <i>undefined</i> is returned.
         * @param callback The function to run on each item of the stream: function(item:*):Boolean.
         * @param reverse
         * @return An item that satisfies provided testing callback; otherwise <i>undefined</i> is returned.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     var item:int = s.find(function(item:Number):Boolean
         *     {
         *        return item > 1;
         *     });
         *     trace(item);
         *     //2
         * </pre>
         */
        public function find(callback:Function, reverse:Boolean = false):*
        {
            if(reverse)
            {
                for(var k:int = source.length - 1; k > 0; k--)
                {
                    if(callback(source[k]))
                    {
                        return source[k];
                    }
                }
            }
            else
            {
                for(var i:int = 0; i < source.length; i++)
                {
                    if(callback(source[i]))
                    {
                        return source[i];
                    }
                }
            }

            return undefined;
        }

        /**
         * Creates a new stream from items of the current stream skipping last <i>n</i> items.
         * @param n An integer that specifies how may items to skip.
         * @return A new stream without <i>n</i> last items.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     var d:Stream = s.drop(2);
         *     trace(d);
         *     //Stream{1}
         * </pre>
         */
        public function drop(n:uint):Stream
        {
            return this.slice(0, length - n);
        }

        /**
         * Returns stream item at specified index.
         * @param index An integer that specifies the position of the item in the stream.
         * @return An item at specified position.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     var item:Number = s.getItem(1);
         *     trace(item);
         *     //2
         * </pre>
         */
        public function getItem(index:int):*
        {
            return source[index];
        }

        /**
         * Sets item at specified position.
         * @param index An integer that specifies the position in the stream where the item is to be set.
         * @param value An item to set.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     s.setItem(1, 4);
         *     trace(s);
         *     //Stream{1, 4, 3}
         * </pre>
         */
        public function setItem(index:int, value:*):void
        {
            source[index] = value;
        }

        /**
         * Executes a test function on each item and calculates number of successful tests.
         * @param callback The function to run on each item in the stream.
         * @return A number of successful tests.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     var count:int = s.count(function(item:Number):Boolean
         *     {
         *        return item > 1;
         *     });
         *     trace(count);
         *     //2
         * </pre>
         */
        public function count(callback:Function):uint
        {
            var result:uint = 0;
            for each (var item:* in source)
            {
                if(callback(item))
                {
                    result++;
                }
            }
            return result;
        }


        /**
         * Checks if the stream contains specified item
         * @param item An item to check.
         * @return A Boolean value of true if stream contains an item; otherwise false.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     var b:Boolean = s.contains(2);
         *     trace(b);
         *     //true
         * </pre>
         */
        public function contains(item:*):Boolean
        {
            return indexOf(item) > -1;
        }

        /**
         * Removes all items from the stream.
         * @return Current stream.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     s.clear();
         *     trace(s);
         *     //Stream{}
         * </pre>
         */
        public function clear():Stream
        {
            source = [];
            return this;
        }

        /**
         * Returns a Boolean value of true if Stream does not contain any items; otherwise false.
         * @example
         * <pre>
         *     var s:Stream = $();
         *     trace(s.empty);
         *     //true
         * </pre>
         */
        public function get empty():Boolean
        {
            return length == 0;
        }

        /**
         * Creates a new stream that contains items starting from count index.
         * @param count A number of items to skip
         * @return A new stream that contains items starting from count index.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     var c:Stream = s.skip(2);
         *     trace(c);
         *     //Stream{3}
         * </pre>
         */
        public function skip(count:int):Stream
        {
            return this.slice(count);
        }

        /**
         * Returns a Boolean value of true if the stream contains unique items; otherwise false.
         * @example
         * <pre>
         *     var s:Stream = $(1, 1, 3);
         *     trace(s.unique);
         *     //false
         * </pre>
         */
        public function get unique():Boolean
        {
            var result:* = source.concat().sort(Array.UNIQUESORT);
            return result != 0;
        }

        /**
         * The first item of the stream
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.first);
         *     //1
         * </pre>
         */
        public function get first():*
        {
            return source[0];
        }

        /**
         * @private
         */
        public function set first(item:*):void
        {
            source[0] = item;
        }

        /**
         * The second item of the stream
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.second);
         *     //2
         * </pre>
         */
        public function get second():*
        {
            return source[1];
        }

        /**
         * @private
         */
        public function set second(item:*):void
        {
            source[1] = item;
        }

        /**
         * The third item of the stream
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.third);
         *     //3
         * </pre>
         */
        public function get third():*
        {
            return source[2];
        }

        /**
         * @private
         */
        public function set third(item:*):void
        {
            source[2] = item;
        }

        /**
         * The fourth item of the stream
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.fourth);
         *     //4
         * </pre>
         */
        public function get fourth():*
        {
            return source[3];
        }

        /**
         * @private
         */
        public function set fourth(item:*):void
        {
            source[3] = item;
        }

        /**
         * The fifth item of the stream
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.fifth);
         *     //5
         * </pre>
         */
        public function get fifth():*
        {
            return source[4];
        }

        /**
         * @private
         */
        public function set fifth(item:*):void
        {
            source[4] = item;
        }

        /**
         * The sixth item of the stream
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.sixth);
         *     //6
         * </pre>
         */
        public function get sixth():*
        {
            return source[5];
        }

        /**
         * @private
         */
        public function set sixth(item:*):void
        {
            source[5] = item;
        }

        /**
         * The seventh of the stream
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.seventh);
         *     //7
         * </pre>
         */
        public function get seventh():*
        {
            return source[6];
        }

        /**
         * @private
         */
        public function set seventh(item:*):void
        {
            source[6] = item;
        }

        /**
         * The eighth item of the stream
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.eighth);
         *     //8
         * </pre>
         */
        public function get eighth():*
        {
            return source[7];
        }

        /**
         * @private
         */
        public function set eighth(item:*):void
        {
            source[7] = item;
        }

        /**
         * The ninth item of the stream
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.ninth);
         *     //9
         * </pre>
         */
        public function get ninth():*
        {
            return source[8];
        }

        /**
         * @private
         */
        public function set ninth(item:*):void
        {
            source[8] = item;
        }

        /**
         * The tenth item of the stream
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.tenth);
         *     //10
         * </pre>
         */
        public function get tenth():*
        {
            return source[9];
        }

        /**
         * @private
         */
        public function set tenth(item:*):void
        {
            source[9] = item;
        }

        /**
         * The eleventh item of the stream
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.eleventh);
         *     //11
         * </pre>
         */
        public function get eleventh():*
        {
            return source[10];
        }

        /**
         * @private
         */
        public function set eleventh(item:*):void
        {
            source[10] = item;
        }

        /**
         * The twelfth item of the stream
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.twelfth);
         *     //12
         * </pre>
         */
        public function get twelfth():*
        {
            return source[11];
        }

        /**
         * @private
         */
        public function set twelfth(item:*):void
        {
            source[11] = item;
        }

        /**
         * The thirteenth item of the stream
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.thirteenth);
         *     //13
         * </pre>
         */
        public function get thirteenth():*
        {
            return source[12];
        }

        /**
         * @private
         */
        public function set thirteenth(item:*):void
        {
            source[12] = item;
        }

        /**
         * The fourteenth item of the stream
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.fourteenth);
         *     //14
         * </pre>
         */
        public function get fourteenth():*
        {
            return source[13];
        }

        /**
         * @private
         */
        public function set fourteenth(item:*):void
        {
            source[13] = item;
        }

        /**
         * The fifteenth item of the stream
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.fifteenth);
         *     //15
         * </pre>
         */
        public function get fifteenth():*
        {
            return source[14];
        }

        /**
         * @private
         */
        public function set fifteenth(item:*):void
        {
            source[14] = item;
        }

        /**
         * The last item of the stream
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.last);
         *     //15
         * </pre>
         */
        public function get last():*
        {
            return source[source.length - 1];
        }

        /**
         * @private
         */
        public function set last(item:*):void
        {
            source[source.length - 1] = item;
        }

        /**
         * Applies a binary callback to a start value and all items of this stream, going left to right.
         * @param callback The function to execute on each value in the stream: function(item:*, accumulator:*):*.
         * @param initial The initial value for the accumulator.
         * @return The value of accumulator.
         * @example
         * <pre>
         *     var sum:Number = $(0, 1, 2, 3, 4).foldLeft(function (prev:Number, current:Number):Number
         *     {
         *        return prev + current;
         *     }, 0);
         *     trace(sum);
         *     //10
         * </pre>
         */
        public function foldLeft(callback:Function, initial:* = undefined):*
        {
            if(initial === undefined && source.length == 0)
            {
                throw new Error("Stream is empty");
            }

            var context:* = initial === undefined ? first : initial;
            var start:int = initial === undefined ? 0 : 1;
            for (var i:int = start; i < source.length; i++)
            {
                context = callback(source[i], context);
            }
            return context;
        }

        /**
         * Applies a binary callback to all items of this stream and a start value, going right to left.
         * @param callback The function to execute on each value in the stream: function(item:*, accumulator:*):*.
         * @param initial The initial value for the accumulator.
         * @return The value of accumulator.
         * @example
         * <pre>
         *     var sum:Number = $(0, 1, 2, 3, 4).foldRight(function (prev:Number, current:Number):Number
         *     {
         *        return prev + current;
         *     }, 0);
         *     trace(sum);
         *     //10
         * </pre>
         */
        public function foldRight(callback:Function, initial:* = undefined):*
        {
            if(initial === undefined && source.length == 0)
            {
                throw new Error("Stream is empty");
            }

            var context:* = initial === undefined ? last : initial;
            var start:int = initial === undefined ? source.length - 2 : source.length - 1;
            for (var i:int = start; i > 0; i--)
            {
                context = callback(source[i], context);
            }
            return context;
        }

        /**
         * Creates a new stream that contains count of items starting from offset.
         * @param count The maximum items to take.
         * @param offset The index to start from.
         * @return A new stream that contains count of items starting from offset.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     var c:Stream = s.take(2, 0);
         *     trace(c);
         *     //Stream{1, 2}
         * </pre>
         */
        public function take(count:int, offset:uint = 0):Stream
        {
            return slice(offset, offset + count);
        }

        /**
         * Flattens a nested Streams, ArrayLists, ArrayCollections, Vectors.
         * @return A new stream from items of the nested Streams, ArrayLists, ArrayCollections, Vectors.
         * @example
         * <pre>
         *     var s:Stream = new Stream([[1], [2], [3]]);
         *     trace(s);
         *     //Stream{[1], [2], [3]}
         *     var c:Stream = s.flatten();
         *     trace(c);
         *     //Stream{1, 2, 3}
         * </pre>
         */
        public function flatten():Stream
        {
            return flatMap(null);
        }

        /**
         * Builds a new stream by applying a function to all items of this stream and using
         * the items of the resulting Streams, ArrayLists, ArrayCollections, Vectors.
         * @param callback The function to execute on each value in the stream: function(item:*):*.
         * @return A new stream that contains flatten results of callback.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     var c:Stream = s.flatMap(function(item:Number):Array
         *     {
         *        return [item];
         *     });
         *     trace(c);
         *     //Stream{1, 2, 3}
         * </pre>
         */
        public function flatMap(callback:Function):Stream
        {
            var f:Function = function (item:*):*
            {
                var result:Array = null;
                if(item is Array)
                {
                    result = item;
                }
                else if(Flex.available && item is Flex.list)
                {
                    result = item.toArray();
                }
                else if(item is Stream)
                {
                    result = Stream(item).source;
                }
                else if(item is Vector.<*> || item is Vector.<Number> || item is Vector.<int> || item is Vector.<uint>)
                {
                    result = [];
                    for(var i:int = 0; i < item.length; i++)
                    {
                        result.push(item[i]);
                    }
                }
                else
                {
                    result = [item];
                }
                return result;
            };

            var mapped:Stream = callback != null ? this.map(callback).map(f) : this.map(f);
            return new Stream().concat(mapped);
        }

        /**
         * Creates a new ArrayCollection from items of current Stream
         */
        public function collection():ArrayCollection
        {
            return new ArrayCollection(source.concat());
        }

        /**
         * Creates a new ArrayList from items of current Stream
         * @example
         * <pre>
         * </pre>
         */
        public function list():ArrayList
        {
            return new ArrayList(this.source.concat());
        }

        /**
         * Creates a new Array from items of current Stream
         * @example
         * <pre>
         * </pre>
         */
        public function array():Array
        {
            return source.concat();
        }

        /**
         * Creates a new Dictionary from the current stream using specified property values as keys
         * @param property The name of the property to be used as key.
         * @param weak Create a new Dictionary with weak keys.
         * @return A new Dictionary from the current stream using specified property values as keys.
         * @example
         * <pre>
         * </pre>
         */
        public function dictionary(property:String, weak:Boolean = false):Dictionary
        {
            var dict:Dictionary = new Dictionary(weak);
            for each (var item:* in source)
            {
                if(item.hasOwnProperty(property))
                {
                    var value:* = item[property];
                    dict[value] = item;
                }
            }
            return dict;
        }

        /**
         * Groups items by key obtained via callback.
         * @param callback The function to calculate key from item: function(item:*):*
         * @param factory Class to be instantiated and returned instead of Dictionary.
         * @return A new Dictionary or custom class created from <i>factory</i> which contains groups.
         * @example
         * <pre>
         * </pre>
         */
        public function group(callback:Function, factory:Class = null):*
        {
            var dict:* = factory == null ? new Dictionary() : new factory();
            for each (var item:* in source)
            {
                var key:* = callback(item);
                var s:Stream = dict[key];
                if(s == null)
                {
                    s = new Stream();
                    dict[key] = s;
                }
                s.push(item);
            }
            return dict;
        }

        /**
         * Creates new Object from the current stream using specified property as keys
         * @param property The name of the property to be used as key.
         * @return A new Object from current Stream using specified property as keys
         * @example
         * <pre>
         * </pre>
         */
        public function object(property:String):Object
        {
            var dict:Object = {};
            for each (var item:* in source)
            {
                if(item.hasOwnProperty(property))
                {
                    var value:* = item[property];
                    dict[value] = item;
                }
            }
            return dict;
        }

        /**
         * Creates a copy of the current stream
         * @param deep Create a deep copy using AMF serialization.
         * @return A shallow copy of the current stream if <i>deep</i> is false; otherwise creates deep copy.
         * @example
         * <pre>
         * </pre>
         */
        public function clone(deep:Boolean = false):Stream
        {
            if(deep)
            {
                var b:ByteArray = new ByteArray();
                b.writeObject(this);
                b.position = 0;
                return b.readObject();
            }
            else
            {
                return concat();
            }
        }

        /*
         * Array part
         */

        /**
         * Converts the items in a stream to strings,
         * inserts the specified separator between the items,
         * concatenates them, and returns the resulting string.
         * @param sep used as separator
         * @return A string consisting of the items of an array converted to strings
         * and separated by the specified parameter.
         * @example
         * <pre>
         * </pre>
         */
        public function join(sep:* = null):String
        {
            return source.join(sep);
        }

        /**
         * Creates reversed stream from the current one.
         * @return A new reversed stream.
         * @example
         * <pre>
         * </pre>
         */
        public function reverse():Stream
        {
            //don't want to change local array
            return new Stream(source.concat().reverse());
        }

        /**
         * Concatenates the elements specified in the parameters with the
         * elements in a stream and creates a new stream. If the parameters
         * specify an stream, the elements of that array are concatenated.
         * If you don't pass any parameters, the new stream is a duplicate
         * (shallow clone) of the original stream.
         * @param rest A value of any data type (such as numbers, elements, or strings) to be concatenated in a new stream.
         * @return  A new stream that contains the items from this stream followed by items from the parameters.
         * @example
         * <pre>
         * </pre>
         */
        public function concat(...rest):Stream
        {
            var result:Array = source.concat();
            for each (var item:* in rest)
            {
                if(item is Array)
                {
                    result = result.concat.apply(null, item);
                }
                else if(Flex.available && item is Flex.list)
                {
                    result = result.concat.apply(null, item.toArray());
                }
                else if(item is Stream)
                {
                    result = result.concat.apply(null, Stream(item).source);
                }
                else if(item is Vector.<*> || item is Vector.<Number> || item is Vector.<int> || item is Vector.<uint>)
                {
                    for(var i:int = 0; i < item.length; i++)
                    {
                        result.push(item[i]);
                    }
                }
                else
                {
                    result = result.concat.apply(null, [item]);
                }
            }
            return new Stream(result);
        }

        /**
         * Removes the first item from a stream and returns that item.
         * The remaining stream items are moved from their original position, i, to i-1.
         * @return The first item (of any data type) in an stream.
         * @example
         * <pre>
         * </pre>
         */
        public function shift():*
        {
            return source.shift();
        }

        /**
         * Adds one or more items to the beginning of a stream and
         * returns the new length of the stream. The other items in the
         * stream are moved from their original position, i, to i+1.
         * @param rest One or more numbers, elements, or variables to be inserted at the beginning of the stream.
         * @return An integer representing the new length of the stream.
         * @example
         * <pre>
         * </pre>
         */
        public function unshift(...rest):uint
        {
            return source.unshift.apply(null, rest);
        }

        /**
         * Returns a new array that consists of a range of elements from the
         * original stream, without modifying the original stream. The returned stream
         * includes the startIndex item and all items up to, but not including, the endIndex item.
         * @param startIndex A number specifying the index of the starting point for the slice.
         *                  If startIndex is a negative number, the starting point begins at the end of the stream,
         *                  where -1 is the last item.
         * @param endIndex A number specifying the index of the ending point for the slice.
         *                 If you omit this parameter, the slice includes all items from
         *                 the starting point to the end of the stream. If endIndex is a negative number,
         *                 the ending point is specified from the end of the stream, where -1 is the last item.
         * @return A new stream that consists of a range of items from the original stream.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     var c:Stream = s.slice(1, 2);
         *     trace(c);
         *     //Stream{2}
         * </pre>
         */
        public function slice(startIndex:int = 0, endIndex:int = 16777215):Stream
        {
            return new Stream(source.slice(startIndex, endIndex));
        }

        /**
         * Adds items to and removes elements from a stream. This method modifies the stream without making a copy.
         * @param startIndex An integer that specifies the index of the item in the stream
         *                   where the insertion or deletion begins. You can use a negative integer
         *                   to specify a position relative to the end of the stream (for example, -1 is the last item of the stream).
         * @param deleteCount An integer that specifies the number of items to be deleted.
         *                    This number includes the item specified in the startIndex parameter.
         *                    If you do not specify a value for the deleteCount parameter, the method deletes
         *                    all of the values from the startIndex item to the last item in the stream.
         *                    If the value is 0, no items are deleted.
         * @param values An optional list of one or more comma-separated values to insert into the stream
         *               at the position specified in the startIndex parameter.
         * @return  A new stream containing the items that were removed from the original stream.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     var c:Stream = s.splice(1, 1);
         *     trace(s);
         *     //Stream{1, 3}
         *     trace(c);
         *     //Stream{2}
         * </pre>
         */
        public function splice(startIndex:int, deleteCount:uint, ... values):Stream
        {
            return new Stream(source.splice.apply(null, [startIndex, deleteCount].concat(values)));
        }

        /**
         * Sorts the elements in a stream. This method sorts according to Unicode values. (ASCII is a subset of Unicode.)
         * @param rest The arguments specifying a comparison function and one or more values that determine the behavior of the sort.
         * @return The return value depends on whether you pass any arguments.
         * @see com.kemsky.Stream#CASEINSENSITIVE
         * @see com.kemsky.Stream#NUMERIC
         * @see com.kemsky.Stream#DESCENDING
         * @see com.kemsky.Stream#RETURNINDEXEDARRAY
         * @see com.kemsky.Stream#UNIQUESORT
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     s.sort(Stream.DESCENDING);
         *     trace(s);
         *     //Stream{3, 2, 1}
         * </pre>
         */
        public function sort(...rest):Stream
        {
            var result:* = source.sort.apply(null, rest);

            if(result is Number && result == 0)
            {
                //this is error, don't want to trade type safety just for this case
                //see 'unique' method
                throw new Error("Stream is not unique");
            }
            else if(result != source)
            {
                return new Stream(result);
            }

            return this;
        }

        /**
         * Sorts the items in a stream according to one or more fields in the stream.
         * @param names A string that identifies a field to be used as the sort value,
         *              or an array in which the first item represents the primary sort field,
         *              the second represents the secondary sort field, and so on.
         * @param options One or more numbers or names of defined constants, separated
         *                by the bitwise OR (|) operator, that change the sorting behavior.
         * @return The return value depends on whether you pass any parameters.
         * @see com.kemsky.Stream#CASEINSENSITIVE
         * @see com.kemsky.Stream#NUMERIC
         * @see com.kemsky.Stream#DESCENDING
         * @see com.kemsky.Stream#RETURNINDEXEDARRAY
         * @see com.kemsky.Stream#UNIQUESORT
         *
         * @example
         * <pre>
         *     var s:Stream = $({id:1, price: 0}, {id:2, price: 1}, {id:3, price: 2});
         *     s.sortOn("price", Stream.DESCENDING);
         *     trace(s);
         *     //Stream{{id:3, price: 2}, {id:2, price: 1}, {id:1, price: 0}}
         * </pre>
         */
        public function sortOn(names:Object, options:Object = null):*
        {
            var result:* = source.sortOn.apply(null, [names, options]);

            if(result is Number && result == 0)
            {
                throw new Error("Stream is not unique");
            }
            else if(result != source)
            {
                return new Stream(result);
            }

            return this;
        }

        /**
         * Searches for an item in an stream by using strict equality (===) and returns the index position of the item.
         * @param item The item to find in the stream.
         * @param fromIndex The location in the stream from which to start searching for the item.
         * @return A zero-based index position of the item in the stream. If the searchElement
         * argument is not found, the return value is -1.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     trace(s.indexOf(2));
         *     //1
         * </pre>
         */
        public function indexOf(item:*, fromIndex:* = 0):int
        {
            return source.indexOf(item, fromIndex);
        }

        /**
         * Searches for an item in an stream, working backward from the last item, and returns
         * the index position of the matching item using strict equality (===).
         * @param item The item to find in the stream.
         * @param fromIndex  The location in the stream from which to start searching for the item.
         *                   The default is the maximum value allowed for an index.
         *                   If you do not specify fromIndex, the search starts at the last item in the stream.
         * @return A zero-based index position of the item in the stream. If the searchElement
         * argument is not found, the return value is -1.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 2);
         *     trace(s.lastIndexOf(2));
         *     //3
         * </pre>
         */
        public function lastIndexOf(item:*, fromIndex:* = 2147483647):int
        {
            return source.lastIndexOf(item, fromIndex);
        }

        /**
         * Executes a test function on each item in the stream until an item is reached
         * that returns false for the specified function. You use this method to
         * determine whether all items in a stream meet a criterion, such as
         * having values less than a particular number.
         * @param callback The function to run on each item in the stream.
         *         <p>function(item:*):Boolean</p>
         * @return A Boolean value of true if all items in the stream return true for
         * the specified function; otherwise, false.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     var c:Boolean = s.every(function(item:Number):Boolean
         *     {
         *        return item < 3;
         *     });
         *     trace(c);
         *     //false
         * </pre>
         */
        public function every(callback:Function):Boolean
        {
            return source.every(function (item:*, index:int, array:Array):Boolean
            {
                return callback(item);
            });
        }

        /**
         * Executes a test function on each item in the array and constructs a new stream
         * for all items that return true for the specified function. If an item returns
         * false, it is not included in the new stream.
         * @param callback The function to run on each item in the stream.
         *         <p>function(item:*):Boolean</p>
         * @return A new stream that contains all items from the original stream that returned true.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     var c:Stream = s.filter(function(item:Number):Boolean
         *     {
         *        return item < 3;
         *     });
         *     trace(c);
         *     //Stream{1, 2}
         * </pre>
         */
        public function filter(callback:Function):Stream
        {
            return new Stream(source.filter(function (item:*, index:int, array:Array):Boolean
            {
                return callback(item);
            }));
        }

        /**
         * Executes a function on each item in the stream.
         * @param callback The function to run on each item in the stream.
         *         <p>function(item:*):void</p>
         * @return Current stream
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     s.forEach(function(item:Number):void
         *     {
         *         trace(item);
         *     });
         *     //1
         *     //2
         *     //3
         * </pre>
         */
        public function forEach(callback:Function):Stream
        {
            source.forEach(function (item:*, index:int, array:Array):void
            {
                callback(item);
            });
            return this;
        }

        /**
         * Executes a function on each item in a stream, and constructs a new
         * stream of items corresponding to the results of the function on each
         * item in the original stream.
         * @param callback The function to run on each item in the stream.
         *         <p>function(item:*):Boolean</p>
         * @return A new stream that contains the results of the function on each item in the original stream.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     var c:Stream = s.map(function(item:Number):Array
         *     {
         *        return [item];
         *     });
         *     trace(c);
         *     //Stream{[1], [2], [3]}
         * </pre>
         */
        public function map(callback:Function):Stream
        {
            return new Stream(source.map(function (item:*, index:int, array:Array):*
            {
                return callback(item);
            }));
        }

        /**
         * Executes a test function on each item in the stream until an item is reached
         * that returns true. Use this method to determine whether any items in a
         * stream meet a criterion, such as having a value less than a particular number.
         * @param callback The function to run on each item in the stream.
         *                 <p>function(item:*):Boolean</p>
         * @return  A Boolean value of true if any items in the stream return true for
         * the specified function; otherwise false.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     var c:Boolean = s.some(function(item:Number):Boolean
         *     {
         *        return item > 2;
         *     });
         *     trace(c);
         *     //true
         * </pre>
         */
        public function some(callback:Function):Boolean
        {
            return source.some(function (item:*, index:int, array:Array):Boolean
            {
                return callback(item);
            });
        }

        /**
         * Adds one or more items to the end of a stream and returns the new length of the stream.
         * @param rest One or more values to append to the stream.
         * @return An integer representing the new length of the stream.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     s.push(4);
         *     trace(s);
         *     //Stream{1, 2, 3, 4}
         * </pre>
         */
        public function push(...rest):uint
        {
            return source.push.apply(null, rest);
        }

        /**
         * Removes the last item from a stream and returns the value of that item.
         * @return The value of the last item (of any data type) in the specified stream.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     trace(s.pop());
         *     //3
         * </pre>
         */
        public function pop():*
        {
            return source.pop();
        }

        /**
         * A non-negative integer specifying the number of items in the stream.
         * This property is automatically updated when new items are added to the stream.
         * When you assign a value to a stream item (for example, my_stream[index] = value),
         * if index is a number, and index+1 is greater than the length property,
         * the length property is updated to index+1.<p/>
         *
         * <b>Note</b>: If you assign a value to the length property that is shorter
         * than the existing length, the stream will be truncated.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     trace(s.length);
         *     //3
         * </pre>
         */
        public function get length():int
        {
            return source.length;
        }

        /**
         * @private
         */
        public function set length(value:int):void
        {
            source.length = value;
        }

        /**
         * @private
         */
        override flash_proxy function getDescendants(name:*):*
        {
            var result:Array = [];

            for each (var item:* in source)
            {
                if(item != null && item.hasOwnProperty(name))
                {
                    result.push(item[name]);
                }
            }
            return new Stream(result);
        }

        /**
         * @private
         */
        override flash_proxy function getProperty(name:*):*
        {
            var index:Number = NaN;
            try
            {
                // If caller passed in a number such as 5.5, it will be floored.
                index = parseInt(String(name));
            }
            catch(e:Error) // localName was not a number
            {
            }

            if(isNaNFast(index))
            {
                throw new Error("Incorrect index: " + String(name));
            }
            else
            {
                return index < 0 ? source[source.length + index] : source[index];
            }
        }

        /**
         * @private
         */
        override flash_proxy function setProperty(name:*, value:*):void
        {
            var index:Number = NaN;
            try
            {
                // If caller passed in a number such as 5.5, it will be floored.
                index = parseInt(String(name));
            }
            catch(e:Error) // localName was not a number
            {
            }

            if(isNaNFast(index))
            {
                throw new Error("Incorrect index: " + String(name));
            }
            else
            {
                if(index < 0)
                {
                    source[index] = value;
                }
                else
                {
                    source[source.length + index] = value;
                }
            }
        }

        /**
         * @private
         */
        override flash_proxy function hasProperty(name:*):Boolean
        {
            var index:Number = NaN;
            try
            {
                // If caller passed in a number such as 5.5, it will be floored.
                index = parseInt(String(name));
            }
            catch(e:Error) // localName was not a number
            {
            }

            if(isNaNFast(index))
            {
                return false;
            }

            return (index >= 0 && index < source.length) || (index < 0 && index >= -source.length);
        }

        /**
         * @private
         */
        override flash_proxy function nextNameIndex(index:int):int
        {
            return index < length ? index + 1 : 0;
        }

        /**
         * @private
         */
        override flash_proxy function nextName(index:int):String
        {
            return (index - 1).toString();
        }

        /**
         * @private
         */
        override flash_proxy function nextValue(index:int):*
        {
            return source[index - 1];
        }

        /**
         * @private
         */
        override flash_proxy function callProperty(name:*, ...rest):*
        {
            if(rest.length != 1 || !(rest[0] is Function))
            {
                throw new Error("Shortcut filter must have exactly one parameter (Function)");
            }

            var criteria:Function = rest[0] as Function;

            return this.filter(function (item:*):Boolean
            {
                return item != null && item.hasOwnProperty(name) && criteria(item[name]);
            });
        }

        /**
         * @private
         */
        override flash_proxy function deleteProperty(name:*):Boolean
        {
            var index:Number = NaN;
            try
            {
                // If caller passed in a number such as 5.5, it will be floored.
                index = parseInt(String(name));
            }
            catch(e:Error) // localName was not a number
            {
            }

            if(isNaNFast(index))
            {
                return false;
            }

            if(index < 0)
            {
                return (source.splice(source.length + index, 1) as Array).length > 0;
            }
            else
            {
                return (source.splice(index, 1) as Array).length > 0;
            }
        }

        /**
         * @private
         * A class implements this method to decode itself from a data stream by calling
         * the methods of the IDataInput interface. This method must read the values in
         * the same sequence and with the same types as were written by the writeExternal() method.
         * @param input The name of the class that implements the IDataInput interface.
         * @see flash.utils.IExternalizable#readExternal
         */
        public function readExternal(input:IDataInput):void
        {
            source = input.readObject() as Array;
        }

        /**
         * @private
         * A class implements this method to encode itself for a data stream by calling
         * the methods of the IDataOutput interface.
         * @param output The name of the class that implements the IDataOutput interface.
         * @see flash.utils.IExternalizable#readExternal
         */
        public function writeExternal(output:IDataOutput):void
        {
            output.writeObject(source);
        }

        /**
         * Returns the string representation of stream object.
         * @return a String
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     trace(s.toString());
         *     //Stream{1, 2, 3}
         * </pre>
         */
        public function toString():String
        {
            return "Stream{" + source.join(",") + "}";
        }

        /**
         * @private
         */
        private static function isNaNFast(target:*):Boolean
        {
            return !(target <= 0) && !(target > 0);
        }
    }
}
