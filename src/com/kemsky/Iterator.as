package com.kemsky
{
    public interface Iterator
    {
        function get hasPrevious():Boolean;

        function previous():*;

        function get current():*;

        function start():void;

        function end():void;

        function remove():Boolean;

        function get hasNext():Boolean;

        function next():*;

        function put(value:*):void;
    }
}
