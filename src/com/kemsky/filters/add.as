package com.kemsky.filters
{
    /**
     * Creates function that calculates sum of provided arguments for an item
     * @param rest arguments
     * @return function that calculates sum of provided arguments
     */
    public function add(...rest):Function
    {
        return function (item:*):*
        {
            var result:Number = 0;
            for each (var f:* in rest)
            {
                if(f is Function)
                {
                    result += f(item);
                }
                else
                {
                    result += f;
                }
            }
            return result;
        };
    }
}
