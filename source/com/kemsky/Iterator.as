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
