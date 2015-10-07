package com.kemsky.impl.filters
{
    public function mapped(val1:*, map:*):Function
    {
        return function (item:*):Boolean
        {
            var key:* = toValue(item, val1);
            if(map is Function)
            {
                return map(key);
            }
            else
            {
                return map.hasOwnProperty(key);
            }
        };
    }
}
