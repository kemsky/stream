package com.kemsky.filters
{
    import com.kemsky.support.toValue;

    public function type(val1:*, clazz:Class):Function
    {
        return function (item:*):Boolean
        {
            return toValue(item, val1) is clazz;
        };
    }
}
