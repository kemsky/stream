package com.kemsky.filters
{
    import com.kemsky.support.Compare;
    import com.kemsky.support.toValue;

    public function le(val1:*, val2:*, options:uint = 0):Function
    {
        return function (item:*):Boolean
        {
            return Compare.compare(toValue(item, val1), toValue(item, val2), options) <= 0;
        };
    }
}
