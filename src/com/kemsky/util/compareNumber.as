package com.kemsky.util
{
    /**
     * @private
     */
    public function compareNumber(fa:Number, fb:Number):int
    {
        if (isNaN(fa) && isNaN(fb))
        {
            return 0;
        }

        if (isNaN(fa))
        {
            return -1;
        }

        if (isNaN(fb))
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
