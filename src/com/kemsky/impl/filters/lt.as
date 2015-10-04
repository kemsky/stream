package com.kemsky.impl.filters
{
    public function lt(val1:*, val2:*):Function
    {
        return function (item:*):Boolean
        {
            return toValue(item, val1) < toValue(item, val2);
        };
    }
}
