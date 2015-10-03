package com.kemsky.impl.filters
{
    public function or(...rest):Function
    {
        return function (item:*):Boolean
        {
            var result:Boolean;
            for each (var f:Function in rest)
            {
                result = f(item);
                if (result)
                {
                    break;
                }
            }
            return result;
        };
    }
}
