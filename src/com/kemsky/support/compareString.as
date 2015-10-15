package com.kemsky.support
{
    /**
     * @private
     */
    public function compareString(fa:String, fb:String, caseInsensitive:Boolean):int
    {
        // Convert to lowercase if we are case insensitive.
        if (caseInsensitive)
        {
            fa = fa.toLocaleLowerCase();
            fb = fb.toLocaleLowerCase();
        }

        var result:int = fa.localeCompare(fb);

        if (result < -1)
        {
            result = -1;
        }
        else if (result > 1)
        {
            result = 1;
        }

        return result;
    }
}
