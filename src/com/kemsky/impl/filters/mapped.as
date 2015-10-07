package com.kemsky.impl.filters
{
    public function mapped(val1:*, map:Object):Function
    {
        return function (item:*):Boolean
        {
            var key:* = toValue(item, val1);
            return map.hasOwnProperty(key);
        };
    }
}
