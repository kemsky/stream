package com.kemsky
{
    /**
     * @private
     */
    public interface Iterator
    {
        function get available():Boolean;

        function next():*;
    }
}
