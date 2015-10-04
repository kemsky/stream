package com.kemsky.impl.filters
{
    /**
     * @private
     */
    public function normalize(item:*, args:Array):Function
    {
        if(args.length > 2 || args.length == 0)
        {
            throw new Error();
        }

        if (args[1] === undefined)
        {
            return function (operator:Function):*
            {
                var a:* = item;
                var b:* = toValue(item, args[0]);
                return operator(a, b);
            };
        }
        return function (operator:Function):*
        {
            var a:* = toValue(item, args[0]);
            var b:* = toValue(item, args[1]);
            return operator(a, b);
        };
    }
}
