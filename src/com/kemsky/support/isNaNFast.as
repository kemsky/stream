package com.kemsky.support
{
    /**
     * Faster alternative to isNaN()
     * @private
     */
    public function isNaNFast(target:*):Boolean
    {
        return !(target <= 0) && !(target > 0);
    }

}
