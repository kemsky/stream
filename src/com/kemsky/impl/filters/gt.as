package com.kemsky.impl.filters
{
    public function gt(value1:*, value2:* = undefined):Function
    {
        return function (item:*):Boolean
        {
            return normalize(item, value1, value2)(function (a:*, b:*):Boolean
            {
                return a > b;
            });
        };
    }
}
