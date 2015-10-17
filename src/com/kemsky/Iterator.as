package com.kemsky
{
    /**
     * Basic iterator interface
     */
    public interface Iterator
    {
        function get available():Boolean;

        function next():*;
    }
}
