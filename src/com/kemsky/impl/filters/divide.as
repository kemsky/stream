package com.kemsky.impl.filters
{
    public function divide(...rest):Function
    {
        return function (item:*):*
        {
            var result:Number = rest[0] is Function ? rest[0](item): rest[0];

            for (var i:int = 1; i < rest.length; i++)
            {
                var f:* = rest[i];
                if(f is Function)
                {
                    result /= f(item);
                }
                else
                {
                    result /= f;
                }
            }
            return result;
        };
    }
}
