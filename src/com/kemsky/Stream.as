package com.kemsky
{
    import com.kemsky.filters._;
    import com.kemsky.filters.defined;
    import com.kemsky.util.*;

    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    import flash.utils.IExternalizable;
    import flash.utils.Proxy;
    import flash.utils.flash_proxy;

    import mx.collections.ArrayCollection;
    import mx.collections.ArrayList;

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
        public var source:Array;

        /**
         *  Constructor.
         *
         *  <p>Creates a new stream using the specified source array.
         *  If no array is specified an empty array will be used.</p>
         */
        public function Stream(source:Array = null)
        {
            this.source = source == null ? [] : source;
        }

        /**
         * Creates a new stream for all items that are not strictly equal to undefined (item !== <i>undefined</i>).
         * @return A new stream that contains all items from the original stream that are not equal to <i>undefined</i>.
         */
        public function compact():Stream
        {
            return filter(defined(_));
        }

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

        public function fill(value:*, length:int = -1):Stream
        {
            var count:uint = length == -1 ? source.length : length;

            for(var i:int = 0; i < count; i++)
            {
                source[i] = value;
            }
            return this;
        }

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

        public function findIndex(callback:Function):int
        {
            var result:int = 0;
            for each (var item:* in source)
            {
                if(callback(item))
                {
                    return result;
                }
                result++;
            }
            return -1;
        }

        public function find(callback:Function):*
        {
            for each (var item:* in source)
            {
                if(callback(item))
                {
                    return item;
                }
            }
            return undefined;
        }

        public function drop(count:uint):Stream
        {
            return this.slice(0, length - count);
        }

        public function getItem(index:int):*
        {
            return source[index];
        }


        public function setItem(index:int, value:*):void
        {
            source[index] = value;
        }

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
         */
        public function contains(item:*):Boolean
        {
            return indexOf(item) > -1;
        }

        /**
         * Removes all items from the stream
         * @return Current stream
         */
        public function clear():Stream
        {
            source = [];
            return this;
        }

        /**
         * Returns a Boolean value of true if Stream does not contain any items; otherwise false.
         */
        public function get empty():Boolean
        {
            return length == 0;
        }

        /**
         * Creates a new stream that contains items starting from count index.
         * @param count A number of items to skip
         * @return A new stream that contains items starting from count index.
         */
        public function skip(count:int):Stream
        {
            return this.slice(count);
        }

        /**
         * Returns a Boolean value of true if the stream contains unique items; otherwise false.
         */
        public function get unique():Boolean
        {
            var result:* = source.concat().sort(Array.UNIQUESORT);
            return result != 0;
        }

        /**
         * The first item of the stream
         */
        public function get first():*
        {
            return source[0];
        }

        public function set first(item:*):void
        {
            source[0] = item;
        }

        /**
         * The second item of the stream
         */
        public function get second():*
        {
            return source[1];
        }

        public function set second(item:*):void
        {
            source[1] = item;
        }

        /**
         * The third item of the stream
         */
        public function get third():*
        {
            return source[2];
        }

        public function set third(item:*):void
        {
            source[2] = item;
        }

        /**
         * The fourth item of the stream
         */
        public function get fourth():*
        {
            return source[3];
        }

        public function set fourth(item:*):void
        {
            source[3] = item;
        }

        /**
         * The fifth item of the stream
         */
        public function get fifth():*
        {
            return source[4];
        }

        public function set fifth(item:*):void
        {
            source[4] = item;
        }

        /**
         * The sixth item of the stream
         */
        public function get sixth():*
        {
            return source[5];
        }

        public function set sixth(item:*):void
        {
            source[5] = item;
        }

        /**
         * The seventh of the stream
         */
        public function get seventh():*
        {
            return source[6];
        }

        public function set seventh(item:*):void
        {
            source[6] = item;
        }

        /**
         * The eighth item of the stream
         */
        public function get eighth():*
        {
            return source[7];
        }

        public function set eighth(item:*):void
        {
            source[7] = item;
        }

        /**
         * The ninth item of the stream
         */
        public function get ninth():*
        {
            return source[8];
        }

        public function set ninth(item:*):void
        {
            source[8] = item;
        }

        /**
         * The tenth item of the stream
         */
        public function get tenth():*
        {
            return source[9];
        }

        public function set tenth(item:*):void
        {
            source[9] = item;
        }

        /**
         * The eleventh item of the stream
         */
        public function get eleventh():*
        {
            return source[10];
        }

        public function set eleventh(item:*):void
        {
            source[10] = item;
        }
        /**
         * The twelfth item of the stream
         */

        public function get twelfth():*
        {
            return source[11];
        }

        public function set twelfth(item:*):void
        {
            source[11] = item;
        }

        /**
         * The thirteenth item of the stream
         */
        public function get thirteenth():*
        {
            return source[12];
        }

        public function set thirteenth(item:*):void
        {
            source[12] = item;
        }

        /**
         * The fourteenth item of the stream
         */
        public function get fourteenth():*
        {
            return source[13];
        }

        public function set fourteenth(item:*):void
        {
            source[13] = item;
        }

        /**
         * The fifteenth item of the stream
         */
        public function get fifteenth():*
        {
            return source[14];
        }

        public function set fifteenth(item:*):void
        {
            source[14] = item;
        }

        /**
         * The last item of the stream
         */
        public function get last():*
        {
            return source[source.length - 1];
        }

        public function set last(item:*):void
        {
            source[source.length - 1] = item;
        }

        public function foldLeft(callback:Function, initial:*):*
        {
            var context:* = initial;
            for each (var item:* in source)
            {
                context = callback(item, context);
            }
            return context;
        }

        public function foldRight(callback:Function, initial:*):*
        {
            var context:* = initial;
            for each (var item:* in source.reverse())
            {
                context = callback(item, context);
            }
            return context;
        }

        /**
         * Creates a new stream that contains count of items starting from offset.
         * @param count The maximum items to take.
         * @param offset The index to start from.
         * @return A new stream that contains count of items starting from offset.
         */
        public function take(count:int, offset:uint = 0):Stream
        {
            return slice(offset, offset + count);
        }

        /**
         * Flattens a nested Streams, ArrayLists, ArrayCollections, Vectors.
         * @return
         */
        public function flatten():Stream
        {
            return flatMap(null);//todo: unlimited depth?
        }

        /**
         * Builds a new stream by applying a function to all items of this stream and using
         * the items of the resulting Streams, ArrayLists, ArrayCollections, Vectors.
         * @param callback
         * @return
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
         * Returns a new ArrayCollection created from items of current Stream
         */
        public function collection():ArrayCollection
        {
            return new ArrayCollection(source.concat());
        }


        /**
         * Returns a new ArrayList created from items of current Stream
         */
        public function list():ArrayList
        {
            return new ArrayList(this.source.concat());
        }

        /**
         * Returns a new Array created from items of current Stream
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
         * @return A copy of the current stream.
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
         */
        public function join(sep:* = null):String
        {
            return source.join(sep);
        }

        /**
         * Creates reversed stream from the current one.
         * @return A new reversed stream.
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
         */
        public function splice(startIndex:int, deleteCount:uint, ... values):Stream
        {
            return new Stream(source.splice.apply(null, [startIndex, deleteCount].concat(values)));
        }

        /**
         * Sorts the elements in a stream. This method sorts according to Unicode values. (ASCII is a subset of Unicode.)
         * @param rest The arguments specifying a comparison function and one or more values that determine the behavior of the sort.
         * @return The return value depends on whether you pass any arguments.
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
         * @return A zero-based index position of the item in the stream. If the searchElement argument is not found, the return value is -1.
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
         * @return A zero-based index position of the item in the stream. If the searchElement argument is not found, the return value is -1.
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
         *         <p><code>function(item:*):Boolean</code></p>
         * @return A Boolean value of true if all items in the stream return true for the specified function; otherwise, false.
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
         *         <p><code>function(item:*):Boolean</code></p>
         * @return A new stream that contains all items from the original stream that returned true.
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
         *         <p><code>function(item:*):void</code></p>
         * @return Current stream
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
         *         <p><code>function(item:*):Boolean</code></p>
         * @return A new stream that contains the results of the function on each item in the original stream.
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
         *                 <p><code>function(item:*):Boolean</code></p>
         * @return  A Boolean value of true if any items in the stream return true for the specified function; otherwise false.
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
         */
        public function push(...rest):uint
        {
            return source.push.apply(null, rest);
        }

        /**
         * Removes the last item from a stream and returns the value of that item.
         * @return The value of the last item (of any data type) in the specified stream.
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
         */
        public function get length():int
        {
            return source.length;
        }

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
         * Returns the string representation of Stream object.
         * @return a String
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
