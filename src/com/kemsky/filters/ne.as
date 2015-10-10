package com.kemsky.filters
{
    import com.kemsky.util.toValue;

    public function ne(val1:*, val2:*, options:uint = 0):Function
    {
        return function (item:*):Boolean
        {
            return compare(toValue(item, val1), toValue(item, val2), options, true) != 0;
        };
    }
}
