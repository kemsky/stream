/*
 *  Copyright: (c) 2015. Turtsevich Alexander
 *
 *  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.html
 */

package com.kemsky.support
{
    import com.kemsky.Iterator;
    import com.kemsky.Stream;

    import flash.utils.Proxy;
    import flash.utils.flash_proxy;

    use namespace flash_proxy;

    /**
     * @private
     */
    public class ValueIterator extends Proxy implements Iterator
    {
        protected var stream:Stream;

        protected var _next:int;

        protected var _current:int = -1;

        public function ValueIterator(array:Stream, index:uint = 0)
        {
            stream = array;

            _next = index >= stream.length ? -1 : index;
        }

        private function get nextIndex():int
        {
            return _next;
        }

        public function get index():int
        {
            return _current;
        }

        public function get item():*
        {
            return stream.getItem(_current);
        }

        public function reset():void
        {
            _next = stream.length ? 0 : -1;
            _current = -1;
        }

        public function end():void
        {
            _next = _current = -1;
        }
        
        public function remove():void
        {
            if (_current == -1)
            {
                throw new StreamError();
            }

            if (_next > 0)
            {
                _next--;
            }

            stream.removeItem(_current);
            _current = -1;
        }

        public function get available():Boolean
        {
            return _next > -1;
        }

        public function next():*
        {
            if (_next == -1)
            {
                throw new StreamError("Iterator is finished or empty");
            }

            _current = _next;
            _next = _next >= stream.length - 1 ? -1 : _next + 1;

            return stream.getItem(_current);
        }

        public function set item(value:*):void
        {
            if (_current == -1 || _current == stream.length)
            {
                throw new StreamError();
            }
            stream.setItem(_current, value);
        }

        /**
         * @private
         */
        override flash_proxy function nextNameIndex(index:int):int
        {
            return available ? nextIndex + 1 : 0;
        }

        /**
         * @private
         */
        override flash_proxy function nextValue(index:int):*
        {
            return next();
        }
    }
}
