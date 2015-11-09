package com.kemsky.filters
{
    import com.kemsky.support.toValue;

    //todo test
    public function exists(val:*):Function
    {
        return function (item:*):Boolean
        {
            var value:* = toValue(item, val);

            //not undefined
            //not null
            //not NaN
            return value !== undefined && value != null && (value is Number ? value == value : true);
        };
    }
}
