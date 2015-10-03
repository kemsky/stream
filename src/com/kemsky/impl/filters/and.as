package com.kemsky.impl.filters
{
    public function and(...rest):Function
    {
        return function (item:*):Boolean
        {
            var result:Boolean = true;
            for each (var f:Function in rest)
            {
                result = result && f(item);
                if (!result)
                {
                    break;
                }
            }
            return result;
        };
    }
}
