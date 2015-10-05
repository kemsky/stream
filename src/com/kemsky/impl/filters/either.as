package com.kemsky.impl.filters
{
    import com.kemsky.$;
    import com.kemsky.impl.Stream;

    public function either(val1:*, ...rest):Function
    {
        var values:Stream = $.apply(null, rest);

        if (values.length == 0)
        {
            throw new Error();
        }

        return function (item:*):Boolean
        {
            var val:* = toValue(item, val1);

            var result:Boolean = values.some(function (val2:*):Boolean
            {
                return val == toValue(item, val2);
            });

            return result;
        };
    }
}
