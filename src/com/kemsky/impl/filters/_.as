package com.kemsky.impl.filters
{
    /**
     * Loopback function, allows to use item itself as an argument to filter functions
     * @param item current Stream item
     * @return item passed as argument
     * @see com.kemsky.impl.Stream#filter
     */
    public function _(item:*):*
    {
        return item;
    }
}
