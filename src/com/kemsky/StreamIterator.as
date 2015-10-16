package com.kemsky
{
    public interface StreamIterator extends Iterator
    {
        function get index():int;

        function get hasPrevious():Boolean;

        function previous():*;

        function get current():*;

        function reset():void;

        function stop():void;

        function set(value:*):void;

        function add(value:*):void;
    }
}
