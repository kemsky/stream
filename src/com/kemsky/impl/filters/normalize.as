package com.kemsky.impl.filters
{
    /**
     * @private
     */
    public function normalize(item:*, arg1:*, arg2:*):Function
    {
        if (arg2 === undefined)
        {
            return function (operator:Function):*
            {
                var a:* = item;
                var b:* = toValue(item, arg1);
                return operator(a, b);
            };
        }
        return function (operator:Function):*
        {
            var a:* = toValue(item, arg1);
            var b:* = toValue(item, arg2);
            return operator(a, b);
        };
    }
}
