package com.kemsky
{
    import com.kemsky.filters._;
    import com.kemsky.filters.defined;
    import com.kemsky.filters.existing;
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
    import mx.collections.IList;

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
        public static const VERSION:String = CONFIG::version;

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
         * Specifies that a sort returns a list that consists of array indices.
         */
        public static const RETURNINDEXEDARRAY:uint = 8;

        /**
         * Specifies the unique sorting requirement for the Stream class sorting methods.
         */
        public static const NUMERIC:uint = 16;

        /**
         *  The source of data in the list.
         */
        stream_internal var source:Array;

        /**
         *  Constructor.
         *
         *  <p>Creates a new list using the specified source array.
         *  If no array is specified an empty array will be used.</p>
         * @example
         * <pre>
         *     var s:Stream = new Stream();
         *     var s:Stream = new Stream([1, 2, 3]);
         * </pre>
         * @internal mutable
         */
        public function Stream(source:Array = null)
        {
            this.source = source == null ? [] : source;
        }

        /**
         * Creates iterator over index-item pairs
         * @return iterator
         * @see Iterator
         * @see Entry
         */
        public function entries():Iterator
        {
            return new EntryIterator(this);
        }

        /**
         * Creates iterator over items
         * @return iterator
         * @see Iterator
         */
        public function values():Iterator
        {
            return new ValueIterator(this);
        }

        /**
         * Finds item which has maximum value (or callback(item) has maximum value)
         * @param callback an optional function to apply to each item
         * @param defaultValue value returned in case stream is empty
         * @return item with maximum value
         * @internal immutable
         */
        public function max(callback:Function = null, defaultValue:* = undefined):*
        {
            if(this.length == 0)
            {
                if(arguments.length == 2)
                {
                    return defaultValue;
                }
                else
                {
                    throw new Error("Stream is empty and defaultValue is not provided");
                }
            }

            if(callback == null)
            {
                callback = _;
            }

            var max:* = first;
            var maxValue:Number = callback(first);

            for each (var current:* in source)
            {
                var result:Number = callback(current);
                if(maxValue < result)
                {
                    maxValue = result;
                    max = current;
                }
            }

            return max;
        }

        /**
         * Finds item which has minimum value (or callback(item) has minimum value)
         * @param callback an optional function to apply to each item
         * @param defaultValue value returned in case stream is empty
         * @return item with minimum value
         * @internal immutable
         */
        public function min(callback:Function = null, defaultValue:* = undefined):*
        {
            if(this.length == 0)
            {
                if(arguments.length == 2)
                {
                    return defaultValue;
                }
                else
                {
                    throw new Error("Stream is empty and defaultValue is not provided");
                }
            }

            if(callback == null)
            {
                callback = _;
            }

            var min:* = first;
            var minValue:Number = callback(first);

            for each (var current:* in source)
            {
                var result:Number = callback(current);
                if(minValue > result)
                {
                    minValue = result;
                    min = current;
                }
            }

            return min;
        }

        /**
         * Creates a new list for all items that match <i>defined</i> or <i>existing</i> filters depending on undefinedOnly parameter.
         * @param undefinedOnly use <i>defined</i> filter
         * @return A new list that contains all items from the original list that are not equal to <i>undefined</i>.
         * @see com.kemsky.filters.defined
         * @see com.kemsky.filters.existing
         * @example
         * <pre>
         *     var s:Stream = new Stream();
         *     s[0] = 1;
         *     s[10] = 2;
         *     var c:Stream = s.compact();
         *     trace(c);
         *     //Stream{1, 2}
         * </pre>
         * @internal immutable
         */
        public function compact(undefinedOnly:Boolean = false):Stream
        {
            if(undefinedOnly)
            {
                return filter(defined(_));
            }
            else
            {
                return filter(existing(_));
            }
        }

        /**
         * Splits current list into two lists depending on testing callback.
         * @param callback A function to run on each item of the list: function(item:*):Boolean.
         * @return A new list containing two lists: the first list from items with positive test and second with negative.
         * @example
         * <pre>
         *      var s:Stream = $(1, 2, 3);
         *      var groups:Stream = s.partition(function (item:Number):Boolean
         *      {
         *          return item &lt; 3;
         *      }
         *      trace(groups);
         *      //Stream{Stream{1, 2}, Stream{3}}
         * </pre>
         * @internal immutable
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
         * Fills current list with provided value.
         * @param value An item used to fill the list.
         * @param length An Integer that specifies the how many items to set.
         * @return Current list.
         * @example
         * <pre>
         *     var s:Stream = $();
         *     s.fill(1, 3);
         *     trace(s);
         *     //Stream{1, 1, 1}
         * </pre>
         * @internal mutable
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
         * Creates a new list of lists created from the items and their corresponding indices.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     var z:Stream = s.zip();
         *     trace(z);
         *     //Stream{Stream{0, 1}, Stream{1, 2}, Stream{2, 3}}
         * </pre>
         * @return A new list of lists created from the items and their corresponding indices.
         * @internal immutable
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
         * Returns an index of the item in the list, if an item in the list satisfies the provided testing callback.
         * Otherwise -1 is returned.
         * @param callback The function to run on each item of the list: function(item:*):Boolean.
         * @param reverse Start search from the end of the list.
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
         * @internal immutable
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
         * Returns a value in the list, if an item in the list satisfies the provided testing callback.
         * Otherwise <i>undefined</i> is returned.
         * @param callback The function to run on each item of the list: function(item:*):Boolean.
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
         * @internal immutable
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
         * Creates a new list from items of the current list skipping last <i>n</i> items.
         * @param n An integer that specifies how may items to skip.
         * @return A new list without <i>n</i> last items.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     var d:Stream = s.drop(2);
         *     trace(d);
         *     //Stream{1}
         * </pre>
         * @internal immutable
         */
        public function drop(n:uint):Stream
        {
            return this.slice(0, length - n);
        }

        /**
         * Returns list item at specified index.
         * @param index An integer that specifies the position of the item in the list.
         * @return An item at specified position.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     var item:Number = s.getItem(1);
         *     trace(item);
         *     //2
         * </pre>
         * @internal immutable
         */
        public function getItem(index:int):*
        {
            return source[index];
        }

        /**
         * Sets item at specified position.
         * @param index An integer that specifies the position in the list where the item is to be set.
         * @param value An item to set.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     s.setItem(1, 4);
         *     trace(s);
         *     //Stream{1, 4, 3}
         * </pre>
         * @internal mutable
         */
        public function setItem(index:int, value:*):void
        {
            source[index] = value;
        }

        /**
         * Adds item to specified position.
         * @param index An integer that specifies the position in the list where the item is to be added to.
         * @param value An item to add.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     s.addItem(1, 4);
         *     trace(s);
         *     //Stream{1, 4, 2, 3}
         * </pre>
         * @internal mutable
         */
        public function addItem(index:int, value:*):void
        {
            if(index <= source.length)
            {
                source.splice(index, 0, value);
            }
            else
            {
                source[index] = value;
            }
        }

        /**
         * Removes item at specified position.
         * @param index An integer that specifies the position in the list.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     s.removeItem(0);
         *     trace(s);
         *     //Stream{2, 3}
         * </pre>
         * @internal mutable
         */
        public function removeItem(index:int):void
        {
            delete this[index];
        }

        /**
         * Executes a test function on each item and calculates number of successful tests.
         * @param callback The function to run on each item in the list.
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
         * @internal immutable
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
         * Checks if the list contains specified item
         * @param item An item to check.
         * @return A Boolean value of true if list contains an item; otherwise false.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     var b:Boolean = s.contains(2);
         *     trace(b);
         *     //true
         * </pre>
         * @internal immutable
         */
        public function contains(item:*):Boolean
        {
            return indexOf(item) > -1;
        }

        /**
         * Removes all items from the list.
         * @return Current list.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     s.clear();
         *     trace(s);
         *     //Stream{}
         * </pre>
         * @internal mutable
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
         * @internal immutable
         */
        public function get empty():Boolean
        {
            return length == 0;
        }

        /**
         * Creates a new list that contains items starting from count index.
         * @param count A number of items to skip
         * @return A new list that contains items starting from count index.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     var c:Stream = s.skip(2);
         *     trace(c);
         *     //Stream{3}
         * </pre>
         * @internal immutable
         */
        public function skip(count:int):Stream
        {
            return this.slice(count);
        }

        /**
         * Returns a Boolean value of true if the list contains unique items; otherwise false.
         * @example
         * <pre>
         *     var s:Stream = $(1, 1, 3);
         *     trace(s.unique);
         *     //false
         * </pre>
         * @internal immutable
         */
        public function get unique():Boolean
        {
            var result:* = source.concat().sort(Array.UNIQUESORT);
            return result != 0;
        }

        /**
         * The first item of the list
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.first);
         *     //1
         *     s.first = -1;
         *     trace(s.first);
         *     //-1
         * </pre>
         * @internal immutable
         */
        public function get first():*
        {
            return source[0];
        }

        /**
         * @private
         * @internal mutable
         */
        public function set first(item:*):void
        {
            source[0] = item;
        }

        /**
         * The second item of the list
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.second);
         *     //2
         * </pre>
         * @internal immutable
         */
        public function get second():*
        {
            return source[1];
        }

        /**
         * @private
         * @internal mutable
         */
        public function set second(item:*):void
        {
            source[1] = item;
        }

        /**
         * The third item of the list
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.third);
         *     //3
         * </pre>
         * @internal immutable
         */
        public function get third():*
        {
            return source[2];
        }

        /**
         * @private
         * @internal mutable
         */
        public function set third(item:*):void
        {
            source[2] = item;
        }

        /**
         * The fourth item of the list
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.fourth);
         *     //4
         * </pre>
         * @internal immutable
         */
        public function get fourth():*
        {
            return source[3];
        }

        /**
         * @private
         * @internal mutable
         */
        public function set fourth(item:*):void
        {
            source[3] = item;
        }

        /**
         * The fifth item of the list
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.fifth);
         *     //5
         * </pre>
         * @internal immutable
         */
        public function get fifth():*
        {
            return source[4];
        }

        /**
         * @private
         * @internal mutable
         */
        public function set fifth(item:*):void
        {
            source[4] = item;
        }

        /**
         * The sixth item of the list
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.sixth);
         *     //6
         * </pre>
         * @internal immutable
         */
        public function get sixth():*
        {
            return source[5];
        }

        /**
         * @private
         * @internal mutable
         */
        public function set sixth(item:*):void
        {
            source[5] = item;
        }

        /**
         * The seventh of the list
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.seventh);
         *     //7
         * </pre>
         * @internal immutable
         */
        public function get seventh():*
        {
            return source[6];
        }

        /**
         * @private
         * @internal mutable
         */
        public function set seventh(item:*):void
        {
            source[6] = item;
        }

        /**
         * The eighth item of the list
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.eighth);
         *     //8
         * </pre>
         * @internal immutable
         */
        public function get eighth():*
        {
            return source[7];
        }

        /**
         * @private
         * @internal mutable
         */
        public function set eighth(item:*):void
        {
            source[7] = item;
        }

        /**
         * The ninth item of the list
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.ninth);
         *     //9
         * </pre>
         * @internal immutable
         */
        public function get ninth():*
        {
            return source[8];
        }

        /**
         * @private
         * @internal mutable
         */
        public function set ninth(item:*):void
        {
            source[8] = item;
        }

        /**
         * The tenth item of the list
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.tenth);
         *     //10
         * </pre>
         * @internal immutable
         */
        public function get tenth():*
        {
            return source[9];
        }

        /**
         * @private
         * @internal mutable
         */
        public function set tenth(item:*):void
        {
            source[9] = item;
        }

        /**
         * The eleventh item of the list
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.eleventh);
         *     //11
         * </pre>
         * @internal immutable
         */
        public function get eleventh():*
        {
            return source[10];
        }

        /**
         * @private
         * @internal mutable
         */
        public function set eleventh(item:*):void
        {
            source[10] = item;
        }

        /**
         * The twelfth item of the list
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.twelfth);
         *     //12
         * </pre>
         * @internal immutable
         */
        public function get twelfth():*
        {
            return source[11];
        }

        /**
         * @private
         * @internal mutable
         */
        public function set twelfth(item:*):void
        {
            source[11] = item;
        }

        /**
         * The thirteenth item of the list
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.thirteenth);
         *     //13
         * </pre>
         * @internal immutable
         */
        public function get thirteenth():*
        {
            return source[12];
        }

        /**
         * @private
         * @internal mutable
         */
        public function set thirteenth(item:*):void
        {
            source[12] = item;
        }

        /**
         * The fourteenth item of the list
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.fourteenth);
         *     //14
         * </pre>
         * @internal immutable
         */
        public function get fourteenth():*
        {
            return source[13];
        }

        /**
         * @private
         * @internal mutable
         */
        public function set fourteenth(item:*):void
        {
            source[13] = item;
        }

        /**
         * The fifteenth item of the list
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.fifteenth);
         *     //15
         * </pre>
         * @internal immutable
         */
        public function get fifteenth():*
        {
            return source[14];
        }

        /**
         * @private
         * @internal mutable
         */
        public function set fifteenth(item:*):void
        {
            source[14] = item;
        }

        /**
         * The last item of the list
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
         *     trace(s.last);
         *     //15
         * </pre>
         * @internal immutable
         */
        public function get last():*
        {
            return source[source.length - 1];
        }

        /**
         * @private
         * @internal mutable
         */
        public function set last(item:*):void
        {
            source[source.length - 1] = item;
        }

        /**
         * Applies a binary callback to a start value and all items of this list, going left to right.
         * @param callback The function to execute on each value in the list: function(item:*, accumulator:*):*.
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
         * @internal immutable
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
         * Applies a binary callback to all items of this list and a start value, going right to left.
         * @param callback The function to execute on each value in the list: function(item:*, accumulator:*):*.
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
         * @internal immutable
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
         * Creates a new list that contains count of items starting from offset.
         * @param count The maximum items to take.
         * @param offset The index to start from.
         * @return A new list that contains count of items starting from offset.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     var c:Stream = s.take(2, 0);
         *     trace(c);
         *     //Stream{1, 2}
         * </pre>
         * @internal immutable
         */
        public function take(count:int, offset:uint = 0):Stream
        {
            return slice(offset, offset + count);
        }

        /**
         * Flattens a nested lists, ArrayLists, ArrayCollections, Vectors.
         * @return A new list from items of the nested lists, ArrayLists, ArrayCollections, Vectors.
         * @example
         * <pre>
         *     var s:Stream = new Stream([[1], [2], [3]]);
         *     trace(s);
         *     //Stream{[1], [2], [3]}
         *     var c:Stream = s.flatten();
         *     trace(c);
         *     //Stream{1, 2, 3}
         * </pre>
         * @internal immutable
         */
        public function flatten():Stream
        {
            return flatMap(null);
        }

        /**
         * Builds a new list by applying a function to all items of this list and using
         * the items of the resulting lists, ArrayLists, ArrayCollections, Vectors.
         * @param callback The function to execute on each value in the list: function(item:*):*.
         * @return A new list that contains flatten results of callback.
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
         * @internal immutable
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
                else if(item is IList)
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
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     var c:ArrayCollection = s.collection();
         *     trace(c);
         *     //ArrayCollection{1, 2, 3}
         * </pre>
         * @internal immutable
         */
        public function collection():ArrayCollection
        {
            return new ArrayCollection(source.concat());
        }

        /**
         * Creates a new ArrayList from items of current Stream
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     var c:ArrayList = s.list();
         *     trace(c);
         *     //ArrayList{1, 2, 3}
         * </pre>
         * @internal immutable
         */
        public function list():ArrayList
        {
            return new ArrayList(this.source.concat());
        }

        /**
         * Creates a new Array from items of current Stream
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     var c:Array = s.array();
         *     trace(c);
         *     //[1, 2, 3]
         * </pre>
         * @internal immutable
         */
        public function array():Array
        {
            return source.concat();
        }

        /**
         * Creates a new Dictionary from the current list using specified property values as keys
         * @param property The name of the property to be used as key.
         * @param weak Create a new Dictionary with weak keys.
         * @return A new Dictionary from the current list using specified property values as keys.
         * @example
         * <pre>
         *     var item1:Object = {id: 1, key: "key1"};
         *     var item2:Object = {id: 2, key: "key1"};
         *     var item3:Object = {id: 3, key: "key2"};
         *     var s:Stream = $(item1, item2, item3);
         *     var d:Dictionary = s.dictionary("key");
         *     trace(d["key1"]);
         *     //Stream{item1, item2}
         *     trace(d["key2"]);
         *     //Stream{item3}
         * </pre>
         * @internal immutable
         */
        public function dictionary(property:String = null, weak:Boolean = false):Dictionary
        {
            var dict:Dictionary = new Dictionary(weak);
            for each (var item:* in source)
            {
                if(property != null && property.length > 0)
                {
                    if(item.hasOwnProperty(property))
                    {
                        var value:* = item[property];
                        dict[value] = item;
                    }
                }
                else
                {
                    dict[item] = item;
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
         *     public class Groups
         *     {
         *        public var key1:Stream;
         *        public var key2:Stream;
         *     }
         *
         *     var item1:Object = {id: 1, key: "key1"};
         *     var item2:Object = {id: 2, key: "key1"};
         *     var item3:Object = {id: 3, key: "key2"};
         *     var s:Stream = $(item1, item2, item3);
         *     var d:Groups = s.group("key", Groups);
         *     trace(d.key1);
         *     //Stream{item1, item2}
         *     trace(d.key2);
         *     //Stream{item3}
         * </pre>
         * @internal immutable
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
         * Creates new Object from the current list using specified property as keys
         * @param property The name of the property to be used as key.
         * @return A new Object from current Stream using specified property as keys
         * @example
         * <pre>
         *     var item1:Object = {id: 1, key: "key1"};
         *     var item2:Object = {id: 2, key: "key1"};
         *     var item3:Object = {id: 3, key: "key2"};
         *     var s:Stream = $(item1, item2, item3);
         *     var d:Object = s.object("key");
         *     trace(d["key1"]);
         *     //Stream{item1, item2}
         *     trace(d["key2"]);
         *     //Stream{item3}
         * </pre>
         * @internal immutable
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
         * Creates a copy of the current list
         * @param deep Create a deep copy using AMF serialization.
         * @return A shallow copy of the current list if <i>deep</i> is false; otherwise creates deep copy.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2);
         *     var c:Stream = s.clone();
         *     trace(c);
         *     //Stream{1, 2}
         * </pre>
         * @internal immutable
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

        /**
         * Create new stream from original by removing duplicate items.
         * @param callback is compare function <i>function(a:*, b:*):Boolean</i>.
         * @return new stream without duplicate values.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 1);
         *     trace(s.deduplicate());
         *     //Stream{1, 2, 3}
         * </pre>
         * @internal immutable
         */
        public function deduplicate(callback:Function = null):Stream
        {
            var result:Stream = this.concat();
            var i:int;
            var j:int;

            if(callback != null)
            {
                for(i = 0; i < length - 1; i++)
                {
                    for(j = i + 1; j < length; j++)
                    {
                        if(callback(result.getItem(i), result.getItem(j)))
                        {
                            result.removeItem(j);
                        }
                    }
                }
            }
            else
            {
                for(i = 0; i < length - 1; i++)
                {
                    for(j = i + 1; j < length; j++)
                    {
                        if(result.getItem(i) === result.getItem(j))
                        {
                            result.removeItem(j);
                        }
                    }
                }
            }
            return result;
        }

        /*
         * Array part
         */

        /**
         * Converts the items in a list to strings,
         * inserts the specified separator between the items,
         * concatenates them, and returns the resulting string.
         * @param sep used as separator
         * @return A string consisting of the items of an array converted to strings
         * and separated by the specified parameter.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     trace(s.join(";"));
         *     //1;2;3
         * </pre>
         * @internal immutable
         */
        public function join(sep:* = null):String
        {
            return source.join(sep);
        }

        /**
         * Creates reversed list from the current one.
         * @return A new reversed list.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2);
         *     var c:Stream = s.reverse();
         *     trace(c);
         *     //Stream{2, 1}
         * </pre>
         * @internal immutable
         */
        public function reverse():Stream
        {
            //don't want to change local array
            return new Stream(source.concat().reverse());
        }

        /**
         * Concatenates the elements specified in the parameters with the
         * elements in a list and creates a new list. If the parameters
         * specify an list, the elements of that array are concatenated.
         * If you don't pass any parameters, the new list is a duplicate
         * (shallow clone) of the original list.
         * @param rest A value of any data type (such as numbers, elements, or strings) to be concatenated in a new list.
         * @return  A new list that contains the items from this list followed by items from the parameters.
         * @example
         * <pre>
         *     var a:Stream = $(1, 2);
         *     var b:Stream = $(3);
         *     var s:Stream = a.concat(b);
         *     trace(s);
         *     //Stream{1, 2, 3}
         * </pre>
         * @internal immutable
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
                else if(item is IList)
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
         * Removes the first item from a list and returns that item.
         * The remaining list items are moved from their original position, i, to i-1.
         * @return The first item (of any data type) in an list.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     s.shift();
         *     trace(s);
         *     //Stream{2, 3}
         * </pre>
         * @internal mutable
         */
        public function shift():*
        {
            return source.shift();
        }

        /**
         * Adds one or more items to the beginning of a list and
         * returns the new length of the list. The other items in the
         * list are moved from their original position, i, to i+1.
         * @param rest One or more numbers, elements, or variables to be inserted at the beginning of the list.
         * @return An integer representing the new length of the list.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     s.unshift(0);
         *     trace(s);
         *     //Stream{0, 1, 2, 3}
         * </pre>
         * @internal mutable
         */
        public function unshift(...rest):uint
        {
            return source.unshift.apply(null, rest);
        }

        /**
         * Returns a new array that consists of a range of elements from the
         * original list, without modifying the original list. The returned list
         * includes the startIndex item and all items up to, but not including, the endIndex item.
         * @param startIndex A number specifying the index of the starting point for the slice.
         *                  If startIndex is a negative number, the starting point begins at the end of the list,
         *                  where -1 is the last item.
         * @param endIndex A number specifying the index of the ending point for the slice.
         *                 If you omit this parameter, the slice includes all items from
         *                 the starting point to the end of the list. If endIndex is a negative number,
         *                 the ending point is specified from the end of the list, where -1 is the last item.
         * @return A new list that consists of a range of items from the original list.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     var c:Stream = s.slice(1, 2);
         *     trace(c);
         *     //Stream{2}
         * </pre>
         * @internal immutable
         */
        public function slice(startIndex:int = 0, endIndex:int = 16777215):Stream
        {
            return new Stream(source.slice(startIndex, endIndex));
        }

        /**
         * Adds items to and removes elements from a list. This method modifies the list without making a copy.
         * @param startIndex An integer that specifies the index of the item in the list
         *                   where the insertion or deletion begins. You can use a negative integer
         *                   to specify a position relative to the end of the list (for example, -1 is the last item of the list).
         * @param deleteCount An integer that specifies the number of items to be deleted.
         *                    This number includes the item specified in the startIndex parameter.
         *                    If you do not specify a value for the deleteCount parameter, the method deletes
         *                    all of the values from the startIndex item to the last item in the list.
         *                    If the value is 0, no items are deleted.
         * @param values An optional list of one or more comma-separated values to insert into the list
         *               at the position specified in the startIndex parameter.
         * @return  A new list containing the items that were removed from the original list.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     var c:Stream = s.splice(1, 1);
         *     trace(s);
         *     //Stream{1, 3}
         *     trace(c);
         *     //Stream{2}
         * </pre>
         * @internal mutable
         */
        public function splice(startIndex:int, deleteCount:uint, ... values):Stream
        {
            return new Stream(source.splice.apply(null, [startIndex, deleteCount].concat(values)));
        }

        /**
         * Sorts the elements in a list. This method sorts according to Unicode values. (ASCII is a subset of Unicode.)
         * @param options flag that determines the behavior of the sort.
         * @param callback specifies a comparison function.
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
         * @internal mutable
         */
        public function sort(options:uint = 0, callback:Function = null):Stream
        {
            var result:* = source.sort.apply(null, callback == null ? [options] : [callback, options]);

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
         * Sorts the items in a list according to one or more fields in the list.
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
         * @internal mutable
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
         * Searches for an item in an list by using strict equality (===) and returns the index position of the item.
         * @param item The item to find in the list.
         * @param fromIndex The location in the list from which to start searching for the item.
         * @return A zero-based index position of the item in the list. If the searchElement
         * argument is not found, the return value is -1.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     trace(s.indexOf(2));
         *     //1
         * </pre>
         * @internal immutable
         */
        public function indexOf(item:*, fromIndex:* = 0):int
        {
            return source.indexOf(item, fromIndex);
        }

        /**
         * Searches for an item in an list, working backward from the last item, and returns
         * the index position of the matching item using strict equality (===).
         * @param item The item to find in the list.
         * @param fromIndex  The location in the list from which to start searching for the item.
         *                   The default is the maximum value allowed for an index.
         *                   If you do not specify fromIndex, the search starts at the last item in the list.
         * @return A zero-based index position of the item in the list. If the searchElement
         * argument is not found, the return value is -1.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3, 2);
         *     trace(s.lastIndexOf(2));
         *     //3
         * </pre>
         * @internal immutable
         */
        public function lastIndexOf(item:*, fromIndex:* = 2147483647):int
        {
            return source.lastIndexOf(item, fromIndex);
        }

        /**
         * Executes a test function on each item in the list until an item is reached
         * that returns false for the specified function. You use this method to
         * determine whether all items in a list meet a criterion, such as
         * having values less than a particular number.
         * @param callback The function to run on each item in the list.
         *         <p>function(item:*):Boolean</p>
         * @return A Boolean value of true if all items in the list return true for
         * the specified function; otherwise, false.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     var c:Boolean = s.every(function(item:Number):Boolean
         *     {
         *        return item &lt; 3;
         *     });
         *     trace(c);
         *     //false
         * </pre>
         * @internal immutable
         */
        public function every(callback:Function):Boolean
        {
            return source.every(function (item:*, index:int, array:Array):Boolean
            {
                return callback(item);
            });
        }

        /**
         * Executes a test function on each item in the array and constructs a new list
         * for all items that return true for the specified function. If an item returns
         * false, it is not included in the new list.
         * @param callback The function to run on each item in the list.
         *         <p>function(item:*):Boolean</p>
         * @return A new list that contains all items from the original list that returned true.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     var c:Stream = s.filter(function(item:Number):Boolean
         *     {
         *        return item &lt; 3;
         *     });
         *     trace(c);
         *     //Stream{1, 2}
         * </pre>
         * @internal immutable
         */
        public function filter(callback:Function):Stream
        {
            return new Stream(source.filter(function (item:*, index:int, array:Array):Boolean
            {
                return callback(item);
            }));
        }

        /**
         * Executes a function on each item in the list.
         * @param callback The function to run on each item in the list.
         *         <p>function(item:*):void</p>
         * @return Current list
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
         * @internal immutable
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
         * Executes a function on each item in a list, and constructs a new
         * list of items corresponding to the results of the function on each
         * item in the original list.
         * @param callback The function to run on each item in the list.
         *         <p>function(item:*):Boolean</p>
         * @return A new list that contains the results of the function on each item in the original list.
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
         * @internal immutable
         */
        public function map(callback:Function):Stream
        {
            return new Stream(source.map(function (item:*, index:int, array:Array):*
            {
                return callback(item);
            }));
        }

        /**
         * Executes a test function on each item in the list until an item is reached
         * that returns true. Use this method to determine whether any items in a
         * list meet a criterion, such as having a value less than a particular number.
         * @param callback The function to run on each item in the list.
         *                 <p>function(item:*):Boolean</p>
         * @return  A Boolean value of true if any items in the list return true for
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
         * @internal immutable
         */
        public function some(callback:Function):Boolean
        {
            return source.some(function (item:*, index:int, array:Array):Boolean
            {
                return callback(item);
            });
        }

        /**
         * Adds one or more items to the end of a list and returns the new length of the list.
         * @param rest One or more values to append to the list.
         * @return An integer representing the new length of the list.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     s.push(4);
         *     trace(s);
         *     //Stream{1, 2, 3, 4}
         * </pre>
         * @internal mutable
         */
        public function push(...rest):uint
        {
            return source.push.apply(null, rest);
        }

        /**
         * Removes the last item from a list and returns the value of that item.
         * @return The value of the last item (of any data type) in the specified list.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     trace(s.pop());
         *     //3
         * </pre>
         * @internal mutable
         */
        public function pop():*
        {
            return source.pop();
        }

        /**
         * A non-negative integer specifying the number of items in the list.
         * This property is automatically updated when new items are added to the list.
         * When you assign a value to a list item (for example, my_list[index] = value),
         * if index is a number, and index+1 is greater than the length property,
         * the length property is updated to index+1.<p/>
         *
         * <b>Note</b>: If you assign a value to the length property that is shorter
         * than the existing length, the list will be truncated.
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     trace(s.length);
         *     //3
         * </pre>
         * @internal immutable
         */
        public function get length():int
        {
            return source.length;
        }

        /**
         * @private
         * @internal mutable
         */
        public function set length(value:int):void
        {
            source.length = value;
        }

        /**
         * @private
         * @internal immutable
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
         * @internal immutable
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

            if(index != index)
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
         * @internal mutable
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

            if(index != index)
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
         * @internal immutable
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

            if(index != index)
            {
                return false;
            }

            return (index >= 0 && index < source.length) || (index < 0 && index >= -source.length);
        }

        /**
         * @private
         * @internal immutable
         */
        override flash_proxy function nextNameIndex(index:int):int
        {
            return index < length ? index + 1 : 0;
        }

        /**
         * @private
         * @internal immutable
         */
        override flash_proxy function nextName(index:int):String
        {
            return (index - 1).toString();
        }

        /**
         * @private
         * @internal immutable
         */
        override flash_proxy function nextValue(index:int):*
        {
            return source[index - 1];
        }

        /**
         * @private
         * @internal immutable
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
         * @internal mutable
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

            if(index != index)
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
         * A class implements this method to decode itself from a data list by calling
         * the methods of the IDataInput interface. This method must read the values in
         * the same sequence and with the same types as were written by the writeExternal() method.
         * @param input The name of the class that implements the IDataInput interface.
         * @see flash.utils.IExternalizable#readExternal
         * @internal immutable
         */
        public function readExternal(input:IDataInput):void
        {
            source = input.readObject() as Array;
        }

        /**
         * @private
         * A class implements this method to encode itself for a data list by calling
         * the methods of the IDataOutput interface.
         * @param output The name of the class that implements the IDataOutput interface.
         * @see flash.utils.IExternalizable#readExternal
         * @internal immutable
         */
        public function writeExternal(output:IDataOutput):void
        {
            output.writeObject(source);
        }

        /**
         * Returns the string representation of list object.
         * @return a String
         * @example
         * <pre>
         *     var s:Stream = $(1, 2, 3);
         *     trace(s.toString());
         *     //Stream{1, 2, 3}
         * </pre>
         * @internal immutable
         */
        public function toString():String
        {
            return "Stream{" + source.join(",") + "}";
        }

        /**
         * Creates Stream object from items
         * @param rest objects used as source for Stream
         * @return created Stream object
         * @example
         * <pre>
         *     var s:Stream = Stream.of(1, 2, 3);
         *
         *     //All expressions are equivalent to:
         *     var s:Stream = new Stream([1, 2, 3])
         * </pre>
         * @internal immutable
         */
        public static function of(...rest):Stream
        {
            if (rest.length == 0)
            {
                //empty $
                return new Stream();
            }

            //$ from argument list
            return new Stream(rest.concat());
        }

        /**
         * Creates Stream object from iterable object
         * @param object object used as source for a stream
         * @param callback callback used to map result Stream
         * @return created Stream object
         * @example
         * <pre>
         *     var s:Stream = Stream.from([1, 2, 3]);
         *
         *     //Expression is equivalent to:
         *     var s:Stream = new Stream([1, 2, 3])
         *
         *     var obj:Object = {name1: "first", name2: "second"};
         *     var s:Stream = Stream.from(obj, function(entry:Stream):Stream
         *     {
         *         return entry.first;
         *     });
         *     trace(s);
         *     //prints ["name1", "name2"]
         * </pre>
         * @internal immutable
         */
        public static function from(object:*, callback:Function = null):Stream
        {
            var result:Stream;
            if (object == null || object === undefined)
            {
                //empty $
                result = new Stream();
            }
            else if (object is Array)
            {
                //$ from array
                result = new Stream((object as Array).concat());
            }
            else if (object is Vector.<*> || object is Vector.<Number> || object is Vector.<int> || object is Vector.<uint>)
            {
                var a:Array = [];
                for (var i:int = 0; i < object.length; i++)
                {
                    a[i] = object[i];
                }
                result = new Stream(a);
            }
            else if (object is IList)
            {
                //$ from list
                result = new Stream(object.toArray());
            }
            else if (object is Stream)
            {
                //$ from list
                result = Stream(object).concat();
            }
            else
            {
                result = new Stream();
                for (var prop:String in object)
                {
                    if(object.hasOwnProperty(prop))
                    {
                        result.push(new Stream([prop, object[prop]]));
                    }
                }
            }

            return callback == null ? result : result.map(callback);
        }
    }
}
