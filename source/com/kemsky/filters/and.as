package com.kemsky.filters
{
    /**
     * Creates function that calculates logical AND value of provided arguments for an item
     * @param rest arguments
     * @return function that calculates logical AND value of provided arguments
     */
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
