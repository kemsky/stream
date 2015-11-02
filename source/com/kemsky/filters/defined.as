package com.kemsky.filters
{
    import com.kemsky.support.toValue;

    public function defined(val:*):Function
    {
        return function (item:*):Boolean
        {
            return toValue(item, val) !== undefined;
        };
    }
}
