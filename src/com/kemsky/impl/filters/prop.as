package com.kemsky.impl.filters
{
    public function prop(name:String):Function
    {
        return function (item:*):*
        {
            return item.hasOwnProperty(name) ? item[name] : null;
        };
    }
}
