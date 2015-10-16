package com.kemsky.support
{
    /**
     * Faster alternative to isNaN()
     * Useless in fact, function call is more expensive than isNaN
     * @private
     */
    public function isNaNFast(target:*):Boolean
    {
        return !(target <= 0) && !(target > 0);
    }

}
