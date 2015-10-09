package com.kemsky.impl.filters
{
    /**
     * Creates function that applies logical NOT to provided criteria
     * @param rest arguments
     * @return function that applies logical NOT to provided criteria
     */
    public function not(criteria:Function):Function
    {
        return function (item:*):Boolean
        {
            return !criteria(item);
        };
    }
}
