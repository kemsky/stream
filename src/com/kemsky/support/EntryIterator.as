package com.kemsky.support
{
    import com.kemsky.Entry;
    import com.kemsky.ListIterator;
    import com.kemsky.Stream;

    import flash.utils.Proxy;
    import flash.utils.flash_proxy;

    use namespace flash_proxy;

    /**
     * @private
     */
    public class EntryIterator extends Proxy implements ListIterator
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

        public function get index():int
        {
            return _current;
        }

        public function get hasPrevious():Boolean
        {
            return _next > 0 && stream.length > 0;
        }

        public function previous():*
        {
            if (_next == 0 || !stream.length)
            {
                _current = -1;
                return undefined;
            }

            _next = _next == -1 ? stream.length - 1 : _next - 1;
            _current = _next;

            return stream[_current];
        }

        public function get current():*
        {
            return stream[_current];
        }

        public function reset():void
        {
            _next = stream.length ? 0 : -1;
            _current = -1;
        }

        public function stop():void
        {
            _next = _current = -1;
        }
        
        public function remove():Boolean
        {
            if (_current == -1)
            {
                return false;
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
            _current = -1;
            return true;
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

        public function set(value:*):void
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