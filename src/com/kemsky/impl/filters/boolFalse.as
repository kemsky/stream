package com.kemsky.impl.filters
{
    public function boolFalse(val1:*):Function
    {
        return function (item:*):Boolean
        {
            return !toValue(item, val1);
        };
    }
}
