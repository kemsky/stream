/*
 *  Copyright: (c) 2015. Turtsevich Alexander
 *
 *  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.html
 */

package com.kemsky
{
    public interface Iterator
    {
        function get index():int;

        function get item():*;

        function set item(value:*):void;

        function remove():void;

        function get available():Boolean;

        function next():*;

        function reset():void;

        function end():void;
    }
}
