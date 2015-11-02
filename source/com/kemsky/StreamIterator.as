package com.kemsky
{
    /**
     * @private
     */
    public interface StreamIterator extends Iterator
    {
        function get index():int;

        function get hasPrevious():Boolean;

        function previous():*;

        function get current():*;

        function set current(value:*):void;

        function reset():void;

        function abort():void;

        function push(value:*):void;

        function remove():Boolean;
    }
}
