package com.kemsky.impl.filters
{
    public function ge(val1:*, val2:*):Function
    {
        return function (item:*):Boolean
        {
            return toValue(item, val1) >= toValue(item, val2);
        };
    }
}
