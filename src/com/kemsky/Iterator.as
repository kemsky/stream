package com.kemsky
{
    /**
     * Basic iterator interface
     */
    public interface Iterator
    {
        function remove():Boolean;

        function get hasNext():Boolean;

        function next():*;
    }
}
