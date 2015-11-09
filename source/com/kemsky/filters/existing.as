package com.kemsky.filters
{
    import com.kemsky.support.toValue;

    public function existing(val:*):Function
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
