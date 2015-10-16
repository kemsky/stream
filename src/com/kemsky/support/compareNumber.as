package com.kemsky.support
{
    /**
     * @private
     */
    public function compareNumber(fa:Number, fb:Number):int
    {
        if (isNaNFast(fa) && isNaNFast(fb))
        {
            return 0;
        }

        if (isNaNFast(fa))
        {
            return -1;
        }

        if (isNaNFast(fb))
        {
            return 1;
        }

        if (fa < fb)
        {
            return -1;
        }

        if (fa > fb)
        {
            return 1;
        }

        return 0;
    }
}
