package com.kemsky.filters
{
    /**
     * Loopback (identity function) function, allows to use stream item as an argument for other functions
     * @param item current item
     * @return item passed as an argument
     */
    public function _(item:*):*
    {
        return item;
    }
}
