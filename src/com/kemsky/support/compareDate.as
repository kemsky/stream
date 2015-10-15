package com.kemsky.support
{
    /**
     * @private
     */
    public function compareDate(fa:Date, fb:Date):int
    {
        var na:Number = fa.getTime();
        var nb:Number = fb.getTime();

        if (na < nb)
        {
            return -1;
        }

        if (na > nb)
        {
            return 1;
        }

        return 0;
    }
}
