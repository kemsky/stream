package com.kemsky.impl.filters
{
    public function boolTrue(val1:*):Function
    {
        return function (item:*):Boolean
        {
            return toValue(item, val1);
        };
    }
}
