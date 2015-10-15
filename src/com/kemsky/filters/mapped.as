package com.kemsky.filters
{
    import com.kemsky.support.toValue;

    public function mapped(val1:*, map:Object):Function
    {
        return function (item:*):Boolean
        {
            var v:* = toValue(item, val1);
            return v is String ? map.hasOwnProperty(v): !(map[v] == null || map[v] === undefined);
        };
    }
}
