/*
 *  Copyright: (c) 2015. Turtsevich Alexander
 *
 *  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.html
 */

package com.kemsky
{
    import com.kemsky.support.*;

    import flash.utils.Proxy;
    import flash.utils.flash_proxy;

    use namespace flash_proxy;

    /**
     * @private
     */
    public class Iterator extends Proxy
    {
        protected var stream:Stream;

        protected var _next:int;

        protected var _current:int = -1;

        /**
         * Constructor.
         * @param stream underlying stream.
         */
        public function Iterator(stream:Stream)
        {
            this.stream = stream;
            _next = this.stream.length == 0 ? -1 : 0;
        }

        /**
         * @private
         */
        private function get nextIndex():int
        {
            return _next;
        }

        /**
         * @inheritDoc
         */
        public function get index():int
        {
            return _current;
        }

        /**
         * @inheritDoc
         */
        public function get item():*
        {
            return stream.getItem(_current);
        }

        /**
         * @inheritDoc
         */
        public function reset():void
        {
            _next = stream.length ? 0 : -1;
            _current = -1;
        }

        /**
         * @inheritDoc
         */
        public function stop():void
        {
            _next = _current = -1;
        }

        /**
         * @inheritDoc
         */
        public function remove():void
        {
            if (_current == -1)
            {
                throw new StreamError("Current item is not available");
            }

            if (_next > 0)
            {
                _next--;
            }

            stream.removeItem(_current);
            _current = -1;
        }

        /**
         * @inheritDoc
         */
        public function get hasNext():Boolean
        {
            return _next > -1;
        }

        /**
         * @inheritDoc
         */
        public function next():*
        {
            if (_next == -1)
            {
                throw new StreamError("Next item is not available");
            }

            _current = _next;
            _next = _next >= stream.length - 1 ? -1 : _next + 1;

            return stream.getItem(_current);
        }

        /**
         * @inheritDoc
         */
        public function set item(value:*):void
        {
            if (_current == -1 || _current == stream.length)
            {
                throw new StreamError("Current item is not available");
            }
            stream.setItem(value, _current);
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
        override flash_proxy function nextValue(index:int):*
        {
            return next();
        }
    }
}
