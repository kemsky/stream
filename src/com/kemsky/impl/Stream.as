package com.kemsky.impl
{
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    import flash.utils.IExternalizable;
    import flash.utils.Proxy;
    import flash.utils.flash_proxy;

    [RemoteClass(alias="com.kemsky.impl.Stream")]
    public dynamic class Stream extends Proxy implements IExternalizable
    {
        public static const CASEINSENSITIVE:uint = 1;
        public static const DESCENDING:uint = 2;
        public static const UNIQUESORT:uint = 4;
        public static const RETURNINDEXEDARRAY:uint = 8;
        public static const NUMERIC:uint = 16;

        public var source:Array;

        public function Stream(source:Array = null)
        {
            this.source = source == null ? [] : source;
        }


        /**
         * Extended part
         * -------------------------------------------
         */

        public function find(callback:Function):*
        {
            for each (var item:* in source)
            {
                if(callback(item))
                {
                    return item;
                }
            }
            return null;
        }

        public function drop(count:uint):Stream
        {
            return this.slice(0, length - count);
        }

        public function get(index:int):*
        {
            return source[index];
        }


        public function set(index:int, value:*):void
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
         * Check if Stream contains specified item
         * @param item
         * @return <b>true</b> if Stream contains item, <b>false</b> in other case
         */
        public function contains(item:*):Boolean
        {
            return indexOf(item) > -1;
        }


        /**
         * Removes all items from Stream
         */
        public function clear():void
        {
            source = [];
        }

        /**
         * Returns <b>true</b> if Stream does not contain any elements,
         * else returns <b>false</b>.
         */
        public function get empty():Boolean
        {
            return length == 0;
        }

        /**
         * Creates new Stream that contains items starting from count index.
         * @param count number of items to skip
         * @return new Stream that contains items starting from count index.
         */
        public function skip(count:int):Stream
        {
            return this.slice(count);
        }

        public function get unique():Boolean
        {
            var result:* = source.concat().sort(Array.UNIQUESORT);
            return result != 0;
        }

        //ordinals

        public function get first():*
        {
            return source[0];
        }

        public function set first(item:*):void
        {
            source[0] = item;
        }

        public function get second():*
        {
            return source[1];
        }

        public function set second(item:*):void
        {
            source[1] = item;
        }

        public function get third():*
        {
            return source[2];
        }

        public function set third(item:*):void
        {
            source[2] = item;
        }

        public function get fourth():*
        {
            return source[3];
        }

        public function set fourth(item:*):void
        {
            source[3] = item;
        }

        public function get fifth():*
        {
            return source[4];
        }

        public function set fifth(item:*):void
        {
            source[4] = item;
        }

        public function get sixth():*
        {
            return source[5];
        }

        public function set sixth(item:*):void
        {
            source[5] = item;
        }

        public function get seventh():*
        {
            return source[6];
        }

        public function set seventh(item:*):void
        {
            source[6] = item;
        }

        public function get eighth():*
        {
            return source[7];
        }

        public function set eighth(item:*):void
        {
            source[7] = item;
        }

        public function get ninth():*
        {
            return source[8];
        }

        public function set ninth(item:*):void
        {
            source[8] = item;
        }

        public function get tenth():*
        {
            return source[9];
        }

        public function set tenth(item:*):void
        {
            source[9] = item;
        }

        public function get eleventh():*
        {
            return source[10];
        }

        public function set eleventh(item:*):void
        {
            source[10] = item;
        }

        public function get twelfth():*
        {
            return source[11];
        }

        public function set twelfth(item:*):void
        {
            source[11] = item;
        }

        public function get thirteenth():*
        {
            return source[12];
        }

        public function set thirteenth(item:*):void
        {
            source[12] = item;
        }

        public function get fourteenth():*
        {
            return source[13];
        }

        public function set fourteenth(item:*):void
        {
            source[13] = item;
        }

        public function get fifteenth():*
        {
            return source[14];
        }

        public function set fifteenth(item:*):void
        {
            source[14] = item;
        }


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
         * Creates new Stream that contains count of items starting from offset.
         * @param count maximum items to take
         * @param offset index to start from
         * @return new Stream that contains count of items starting from offset.
         */
        public function take(count:int, offset:uint = 0):Stream
        {
            return slice(offset, offset + count);
        }

        public function flatten():Stream
        {
            return flatMap(null);
        }

        public function flatMap(callback:Function):Stream
        {
            var f:Function = function (item:*):*
            {
                var result:Array = null;
                if (item is Array)
                {
                    result = item;
                }
                else if (Flex.available && item is Flex.collection)
                {
                    result = item.source;
                }
                else if (Flex.available && item is Flex.list)
                {
                    result = item.toArray();
                }
                else if (item is Stream)
                {
                    result = Stream(item).source;
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

        CONFIG::flex {

            import mx.collections.ArrayCollection;
            import mx.collections.ArrayList;

            /**
             * Returns new ArrayCollection created from items of current Stream
             */
            public function get collection():ArrayCollection
            {
                return new ArrayCollection(source.concat());
            }


            /**
             * Returns new ArrayList created from items of current Stream
             */
            public function get list():ArrayList
            {
                return new ArrayList(this.source.concat());
            }

        }

        /**
         * Returns new Array created from items of current Stream
         */
        public function get array():Array
        {
            return source.concat();
        }

        /**
         * Creates new Dictionary from current Stream using specified property as keys
         * @param property name of the property to be used as key
         * @param weak create Dictionary with weak keys
         * @return A new Dictionary from current Stream using specified property as keys
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
         * Creates new Object from current Stream using specified property as keys
         * @param property name of the property to be used as key
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
         * Creates a copy of current Stream
         * @param deep create deep copy using AMF serialization trick
         * @return A copy of current Stream
         */
        public function clone(deep:Boolean = false):Stream
        {
            if (deep)
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
         * Array part
         * -------------------------------------------
         */

        /**
         * Converts the elements in an array to strings,
         * inserts the specified separator between the elements,
         * concatenates them, and returns the resulting string.
         * @param sep used as separator
         * @return A string consisting of the elements of an array converted to strings
         * and separated by the specified parameter.
         */
        public function join(sep:* = null):String
        {
            return source.join(sep);
        }

        public function reverse():Stream
        {
            //don't want to change local array
            return new Stream(source.concat().reverse());
        }

        public function concat(...rest):Stream
        {
            var result:Array = source.concat();
            for each (var item:* in rest)
            {
                if (item is Array)
                {
                    result = result.concat.apply(null, item);
                }
                else if (Flex.available && item is Flex.collection)
                {
                    result = result.concat.apply(null, item.source);
                }
                else if (Flex.available && item is Flex.collection)
                {
                    result = item.toArray();
                }
                else if (item is Stream)
                {
                    result = result.concat.apply(null, Stream(item).source);
                }
                else
                {
                    result = result.concat.apply(null, item);
                }
            }
            return new Stream(result);
        }

        public function shift():*
        {
            return source.shift();
        }

        public function slice(startIndex:int = 0, endIndex:int = 16777215):Stream
        {
            return new Stream(source.slice(startIndex, endIndex));
        }

        public function unshift(...rest):uint
        {
            return source.unshift.apply(null, rest);
        }

        public function splice(...rest):Stream
        {
            return new Stream(source.splice.apply(null, rest));
        }

        public function sort(...rest):Stream
        {
            var result:* = source.sort.apply(null, rest);

            if (result == 0)
            {
                //this is error, don't want to trade type safety just for this case
                //see 'unique' method
                throw new Error();
            }
            else if (result != source)
            {
                return new Stream(result);
            }

            return this;
        }

        public function sortOn(names:*, options:* = 0, ...rest):*
        {
            var result:* = source.sortOn.apply(null, [names, options].concat(rest));

            if (result == 0)
            {
                return this;
            }
            else if (result != source)
            {
                return new Stream(result);
            }

            return this;
        }

        public function indexOf(searchElement:*, fromIndex:* = 0):int
        {
            return source.indexOf(searchElement, fromIndex);
        }

        public function lastIndexOf(searchElement:*, fromIndex:* = 2147483647):int
        {
            return source.lastIndexOf(searchElement, fromIndex);
        }

        public function every(callback:Function):Boolean
        {
            return source.every(function (item:*, index:int, array:Array):Boolean
            {
                return callback(item);
            });
        }

        public function filter(callback:Function):Stream
        {
            return new Stream(source.filter(function (item:*, index:int, array:Array):Boolean
            {
                return callback(item);
            }));
        }

        public function forEach(callback:Function):Stream
        {
            source.forEach(function (item:*, index:int, array:Array):void
            {
                callback(item);
            });
            return this;
        }

        public function map(callback:Function):Stream
        {
            return new Stream(source.map(function (item:*, index:int, array:Array):*
            {
                return callback(item);
            }));
        }

        public function some(callback:Function):Boolean
        {
            return source.some(function (item:*, index:int, array:Array):Boolean
            {
                return callback(item);
            });
        }

        public function push(...rest):void
        {
            source.push.apply(null, rest);
        }

        public function pop():*
        {
            return source.pop();
        }

        public function get length():int
        {
            return source.length;
        }

        public function set length(value:int):void
        {
            source.length = value;
        }


        /**
         * Proxy part
         * --------------------------------------------
         */

        override flash_proxy function getDescendants(name:*):*
        {
            var result:Array = [];

            if (name is QName)
            {
                name = name.localName;
            }

            for each (var item:* in source)
            {
                if (item != null && item.hasOwnProperty(name))
                {
                    result.push(item[name]);
                }
            }
            return new Stream(result);
        }

        override flash_proxy function getProperty(name:*):*
        {
            if (name is QName)
            {
                name = name.localName;
            }

            var index:int = -1;
            try
            {
                // If caller passed in a number such as 5.5, it will be floored.
                var n:Number = parseInt(String(name));
                if (!isNaNFast(n))
                {
                    index = int(n);
                }
            }
            catch (e:Error) // localName was not a number
            {
            }

            if (index == -1 || index > source.length)
            {
                throw new Error();
            }
            else
            {
                return source[index];
            }
        }

        override flash_proxy function setProperty(name:*, value:*):void
        {
            if (name is QName)
            {
                name = name.localName;
            }

            var index:int = -1;
            try
            {
                // If caller passed in a number such as 5.5, it will be floored.
                var n:Number = parseInt(String(name));
                if (!isNaNFast(n))
                {
                    index = int(n);
                }
            }
            catch (e:Error) // localName was not a number
            {
            }

            if (index == -1)
            {
                throw new Error();
            }
            else
            {
                source[index] = value;
            }
        }

        override flash_proxy function hasProperty(name:*):Boolean
        {
            if (name is QName)
            {
                name = name.localName;
            }

            var index:int = -1;
            try
            {
                // If caller passed in a number such as 5.5, it will be floored.
                var n:Number = parseInt(String(name));
                if (!isNaNFast(n))
                {
                    index = int(n);
                }
            }
            catch (e:Error) // localName was not a number
            {
            }

            if (index == -1)
            {
                return false;
            }

            return index >= 0 && index < source.length;
        }

        override flash_proxy function nextNameIndex(index:int):int
        {
            return index < length ? index + 1 : 0;
        }

        override flash_proxy function nextName(index:int):String
        {
            return (index - 1).toString();
        }

        override flash_proxy function nextValue(index:int):*
        {
            return source[index - 1];
        }

        override flash_proxy function callProperty(name:*, ...rest):*
        {
            if (name is QName)
            {
                name = name.localName;
            }

            if (rest.length != 1 || !(rest[0] is Function))
            {
                throw new Error();
            }

            var criteria:Function = rest[0] as Function;

            return this.filter(function (item:*):Boolean
            {
                return item != null && item.hasOwnProperty(name) && criteria(item[name]);
            });
        }

        override flash_proxy function deleteProperty(name:*):Boolean
        {
            if (name is QName)
            {
                name = name.localName;
            }

            var index:int = -1;
            try
            {
                // If caller passed in a number such as 5.5, it will be floored.
                var n:Number = parseInt(String(name));
                if (!isNaNFast(n))
                {
                    index = int(n);
                }
            }
            catch (e:Error) // localName was not a number
            {
            }

            if (index == -1 || index >= source.length)
            {
                return false;
            }

            source.splice(index, 1);

            return true;
        }


        /**
         * IExternalizable part
         * --------------------------------------------
         */

        public function readExternal(input:IDataInput):void
        {
            source = input.readObject() as Array;
        }

        public function writeExternal(output:IDataOutput):void
        {
            output.writeObject(source);
        }

        /**
         * toString() part
         * --------------------------------------------
         */

        public function toString():String
        {
            return "Stream{" + source.join(",") + "}";
        }

        private static function isNaNFast(target:*):Boolean
        {
            return !(target <= 0) && !(target > 0);
        }
    }
}
