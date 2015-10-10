package com.kemsky.filters
{
    import com.kemsky.util.toValue;

    public function defined(val:*):Function
    {
        return function (item:*):Boolean
        {
            return toValue(item, val) !== undefined;
        };
    }
}
