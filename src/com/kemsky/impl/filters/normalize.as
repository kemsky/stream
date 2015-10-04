package com.kemsky.impl.filters
{
    /**
     * @private
     */
    public function normalize(item:*, args:Array):Array
    {
        if (args.length > 2 || args.length == 0)
        {
            throw new Error();
        }

        if (args[1] === undefined)
        {
            return [item, toValue(item, args[0])];
        }
        return [toValue(item, args[0]), toValue(item, args[1])];
    }
}
