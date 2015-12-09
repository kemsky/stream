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
    public interface Iterator
    {
        function get position():int;

        function get current():*;

        function set current(value:*):void;

        function add(value:*):void;

        function remove():void;

        function get hasNext():Boolean;

        function next():*;

        function start():void;

        function stop():void;
    }
}
