package com.kemsky.impl.filters
{
    public function defined(val:*):Function
    {
        return function (item:*):Boolean
        {
            return toValue(item, val) !== undefined;
        };
    }
}
