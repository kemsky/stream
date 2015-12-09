/*
 *  Copyright: (c) 2015. Turtsevich Alexander
 *
 *  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.html
 */

package com.kemsky
{
    /**
     * @private
      */
    public class Entry
    {
        private var _index:int;
        private var iterator:Iterator;

        public function Entry(index:int, iterator:Iterator)
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
            if (iterator.position != _index)
            {
                throw new Error();
            }
            return iterator.current;
        }

        public function set value(value:*):void
        {
            if (iterator.position != _index)
            {
                throw new Error();
            }
            iterator.current = value;
        }
    }
}
