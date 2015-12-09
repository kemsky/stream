/*
 *  Copyright: (c) 2015. Turtsevich Alexander
 *
 *  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.html
 */

package com.kemsky.support
{
    import com.kemsky.Entry;
    import com.kemsky.Iterator;
    import com.kemsky.Stream;

    import flash.utils.Proxy;
    import flash.utils.flash_proxy;

    use namespace flash_proxy;

    /**
     * @private
     */
    public class EntryIterator extends Proxy implements Iterator
    {
        protected var stream:Stream;

        protected var _next:int;

        protected var _current:int = -1;

        public function EntryIterator(array:Stream, index:uint = 0)
        {
            stream = array;

            _next = index >= stream.length ? -1 : index;
        }

        public function get previousIndex():int
        {
            return _next == -1 ? stream.length - 1 : _next - 1;
        }

        public function get nextIndex():int
        {
            return _next;
        }

        public function get position():int
        {
            return _current;
        }

        public function get current():*
        {
            return stream[_current];
        }

        public function start():void
        {
            _next = stream.length ? 0 : -1;
            _current = -1;
        }

        public function stop():void
        {
            _next = _current = -1;
        }
        
        public function remove():void
        {
            if (_current == -1)
            {
                throw new Error();
            }

            if (_current == _next)
            { // removed after previous()
                if (_next >= stream.length - 1)
                {
                    _next = -1;
                }
            }
            else
            { // removed after next()
                if (_next > 0)
                {
                    _next--;
                }
            }

            removeCurrent();
            _current = _next;
        }

        public function get hasNext():Boolean
        {
            return _next > -1;
        }

        public function next():*
        {
            if (_next == -1)
            {
                throw new Error();
            }

            _current = _next;
            _next = _next >= stream.length - 1 ? -1 : _next + 1;

            return new Entry(_current, this);
        }

        public function set current(value:*):void
        {
            if (_current == -1 || _current == stream.length)
            {
                throw new Error();
            }
            stream[_current] = value;
        }

        public function add(value:*):void
        {
            stream.push(value);
            if(_next == -1)
            {
                _next = stream.length - 1;
            }
        }

        protected function removeCurrent():void
        {
            stream.splice(_current, 1);
        }

        /**
         * @private
         */
        override flash_proxy function getDescendants(name:*):*
        {
            throw new Error("Not allowed: getDescendants");
        }

        /**
         * @private
         */
        override flash_proxy function getProperty(name:*):*
        {
            throw new Error("Not allowed: getProperty");
        }

        /**
         * @private
         */
        override flash_proxy function setProperty(name:*, value:*):void
        {
            throw new Error("Not allowed: setProperty");
        }

        /**
         * @private
         */
        override flash_proxy function hasProperty(name:*):Boolean
        {
            throw new Error("Not allowed: hasProperty");
        }

        /**
         * @private
         */
        override flash_proxy function nextNameIndex(index:int):int
        {
            return hasNext ? nextIndex + 1 : 0;
        }

        /**
         * @private
         */
        override flash_proxy function nextName(index:int):String
        {
            return (nextIndex + 1).toString();
        }

        /**
         * @private
         */
        override flash_proxy function nextValue(index:int):*
        {
            return next();
        }

        /**
         * @private
         */
        override flash_proxy function callProperty(name:*, ...rest):*
        {
            throw new Error("Not allowed: callProperty");
        }

        /**
         * @private
         */
        override flash_proxy function deleteProperty(name:*):Boolean
        {
            throw new Error("Not allowed: deleteProperty");
        }
    }
}
