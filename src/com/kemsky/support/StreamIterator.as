package com.kemsky.support
{
    import com.kemsky.Iterator;
    import com.kemsky.Stream;

    /**
     * @private
     */
    public class StreamIterator implements Iterator
    {
        protected var stream:Stream;

        protected var _next:int;

        protected var _current:int = -1;

        public function StreamIterator(array:Stream, index:uint = 0)
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
            return _next && stream.length;
        }

        public function previous():*
        {
            if(_next == 0 || !stream.length)
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

        public function start():void
        {
            _next = stream.length ? 0 : -1;
            _current = -1;
        }

        public function end():void
        {
            _next = _current = -1;
        }

        public function remove():Boolean
        {
            if(_current == -1)
            {
                return false;
            }

            if(_current == _next)
            { // removed after previous()
                if(_next >= stream.length - 1)
                {
                    _next = -1;
                }
            }
            else
            { // removed after next()
                if(_next > 0)
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
            if(_next == -1)
            {
                _current = -1;
                return undefined;
            }

            _current = _next;
            _next = _next >= stream.length - 1 ? -1 : _next + 1;

            return stream[_current];
        }

        public function put(value:*):void
        {
            if(_current == -1 || _current == stream.length)
            {
                throw new Error();
            }
            stream[_current] = value;
        }

        protected function removeCurrent():void
        {
            stream.splice(_current, 1);
        }
    }
}
