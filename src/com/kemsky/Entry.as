package com.kemsky
{
    public class Entry
    {
        private var _index:int;
        private var iterator:ListIterator;

        public function Entry(index:int, iterator:ListIterator)
        {
            this._index = index;
            this.iterator = iterator;
        }

        public function get index():int
        {
            return _index;
        }

        public function get value():*
        {
            if (iterator.index != _index)
            {
                throw new Error();
            }
            return iterator.current;
        }

        public function set value(value:*):void
        {
            if (iterator.index != _index)
            {
                throw new Error();
            }
            iterator.set(value);
        }
    }
}