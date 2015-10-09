package com.kemsky.impl.filters
{
    public function prop(val:*, name:String):Function
    {
        return function (item:*):*
        {
            item = toValue(item, val);
            return item.hasOwnProperty(name) ? item[name] : undefined;
        };
    }
}
