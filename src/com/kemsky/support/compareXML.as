package com.kemsky.support
{
    /**
     * @private
     */
    public function compareXML(a:XML, b:XML, numeric:Boolean, caseInsensitive:Boolean):int
    {
        var result:int = 0;

        if (numeric)
        {
            result = compareNumber(parseFloat(a.toString()), parseFloat(b.toString()));
        }
        else
        {
            result = compareString(a.toString(), b.toString(), caseInsensitive);
        }

        return result;
    }
}
