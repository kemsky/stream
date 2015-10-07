package com.kemsky.impl.filters
{
    public function lt(val1:*, val2:*, options:uint = 0):Function
    {
        return function (item:*):Boolean
        {
            return comparator(toValue(item, val1), toValue(item, val2), options) < 0;
        };
    }
}
