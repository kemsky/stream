package com.kemsky.impl.filters
{
    public function not(criteria:Function):Function
    {
        return function (item:*):Boolean
        {
            return !criteria(item);
        };
    }
}
