package com.kemsky.support
{
    /**
     * @private
     */
    public function compareNumber(fa:Number, fb:Number):int
    {
        if ((!(fa <= 0) && !(fa > 0)) && (!(fb <= 0) && !(fb > 0)))
        {
            return 0;
        }

        if (!(fa <= 0) && !(fa > 0))
        {
            return -1;
        }

        if (!(fb <= 0) && !(fb > 0))
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
