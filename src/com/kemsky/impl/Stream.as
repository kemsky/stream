package com.kemsky.impl
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    import flash.utils.IExternalizable;
    import flash.utils.Proxy;
    import flash.utils.flash_proxy;

    import mx.collections.ArrayCollection;
    import mx.collections.IList;

    [RemoteClass(alias="com.kemsky.impl.Stream")]
    public dynamic class Stream extends Proxy implements IExternalizable, IEventDispatcher, IList
    {
        public static const CASEINSENSITIVE:uint = 1;
        public static const DESCENDING:uint = 2;
        public static const UNIQUESORT:uint = 4;
        public static const RETURNINDEXEDARRAY:uint = 8;
        public static const NUMERIC:uint = 16;

        public var source:Array;

        private var eventDispatcher:EventDispatcher;

        public function Stream(source:Array = null)
        {
            this.eventDispatcher = new EventDispatcher(this);

            this.source = source == null ? [] : source;
        }


        /**
         * IList part, minimal support to use as data provider
         * -------------------------------------------
         */


        public function addItem(item:Object):void
        {
            this.push(item);
        }

        public function addItemAt(item:Object, index:int):void
        {
            this.splice(index, 0, item);
        }

        public function getItemAt(index:int, prefetch:int = 0):Object
        {
            return this[index];
        }

        public function getItemIndex(item:Object):int
        {
            return this.indexOf(item);
        }

        public function itemUpdated(item:Object, property:Object = null, oldValue:Object = null, newValue:Object = null):void
        {
        }

        public function removeAll():void
        {
            this.source.length = 0;
        }

        public function removeItemAt(index:int):Object
        {
            var removed:* = this[index];
            delete this[index];
            return removed;
        }

        public function setItemAt(item:Object, index:int):Object
        {
            var oldItem:Object = this[index];
            this[index] = item;
            return oldItem;
        }

        public function toArray():Array
        {
            return this.array();
        }

        /**
         * Extended part
         * -------------------------------------------
         */

        public function get empty():Boolean
        {
            return length == 0;
        }

        public function skip(count:int):Stream
        {
            return this.slice(count);
        }

        public function get last():*
        {
            return source.length > 0 ? source[source.length - 1] : null;
        }

        public function get first():*
        {
            return source.length > 0 ? source[0] : null;
        }

        public function fold(...rest):*
        {
            if (rest.length == 0)
            {
                return foldLeft(function (current:*, def:*):*
                {
                    return current
                }, null);
            }
            else if (rest.length == 1 && !(rest[0] is Function))
            {
                return foldLeft(function (current:*, def:*):*
                {
                    return current
                }, rest[0]);
            }
            else if (rest.length == 2 && (rest[0] is Function))
            {
                return foldLeft(rest[0], rest[1]);
            }

            throw new Error();

            return null;
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

        public function take(count:int = -1, start:uint = 0):Stream
        {
            return slice(start, start + count);
        }

        public function flatMap(callback:Function = null):Stream
        {
            var f:Function = function (item:*):*
            {
                var result:Array = null;
                if (item is Array)
                {
                    result = item;
                }
                else if (item is ArrayCollection)
                {
                    result = ArrayCollection(item).source;
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

        public function collection():ArrayCollection
        {
            return new ArrayCollection(source.concat());
        }

        public function array():Array
        {
            return source.concat();
        }

        public function dictionary(name:String, weak:Boolean = false):Dictionary
        {
            var dict:Dictionary = new Dictionary(weak);
            for each (var item:* in source)
            {
                var value:* = item[name];
                dict[value] = item;
            }
            return dict;
        }


        public function object(name:String):Object
        {
            var dict:Object = {};
            for each (var item:* in source)
            {
                var value:* = item[name];
                dict[value] = item;
            }
            return dict;
        }

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
         * Array part
         * -------------------------------------------
         */


        public function join(sep:* = null):String
        {
            return source.join(sep);
        }

        public function reverse():Stream
        {
            return new Stream(source.reverse());
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
                else if (item is ArrayCollection)
                {
                    result = result.concat.apply(null, ArrayCollection(item).source);
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
            source.splice.apply(null, rest);
            return this;
        }

        public function sort(...rest):Stream
        {
            var result:* = source.sort.apply(null, rest);

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

        public function each(callback:Function):void
        {
            source.forEach(function (item:*, index:int, array:Array):void
            {
                callback(item);
            });
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
                if (!isNaN(n))
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
                if (!isNaN(n))
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
                if (!isNaN(n))
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
                if (!isNaN(n))
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
         * IEventDispatcher part
         * --------------------------------------------
         */

        public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
        {
            eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }

        public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
        {
            eventDispatcher.removeEventListener(type, listener, useCapture);
        }

        public function dispatchEvent(event:Event):Boolean
        {
            return eventDispatcher.dispatchEvent(event);
        }

        public function hasEventListener(type:String):Boolean
        {
            return eventDispatcher.hasEventListener(type);
        }

        public function willTrigger(type:String):Boolean
        {
            return eventDispatcher.willTrigger(type);
        }


        /*
         * toString() part
         * --------------------------------------------
         */

        public function toString():String
        {
            return "Stream[" + source.join(",") + "]";
        }
    }
}
