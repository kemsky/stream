/*
 *  Copyright: (c) 2015. Turtsevich Alexander
 *
 *  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.html
 */

package com.kemsky
{
    /**
     * An iterator over a stream.
     */
    public interface Iterator
    {
        /**
         * Current item index.
         */
        function get index():int;

        /**
         * Current item.
         */
        function get item():*;

        /**
         * Set current item.
         * @param value
         */
        function set item(value:*):void;

        /**
         * Removes from the underlying stream the last item returned
         * by this iterator.
         */
        function remove():void;

        /**
         * Returns true if iteration has more items.
         */
        function get hasNext():Boolean;

        /**
         * Returns the next item in the iteration.
         * @return next item
         */
        function next():*;

        /**
         * Restart iterator.
         */
        function reset():void;

        /**
         * Stop iterator.
         */
        function end():void;
    }
}
