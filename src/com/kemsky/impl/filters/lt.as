package com.kemsky.impl.filters
{
    public function lt(...rest):Function
    {
        return function (item:*):Boolean
        {
            return normalize(item, rest)(function (a:*, b:*):Boolean
            {
                return a < b;
            });
        };
    }
}
