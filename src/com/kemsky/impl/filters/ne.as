package com.kemsky.impl.filters
{
    public function ne(...rest):Function
    {
        return function (item:*):Boolean
        {
            var args:Array = normalize(item, rest);
            return args[0] != args[1];
        };
    }
}
