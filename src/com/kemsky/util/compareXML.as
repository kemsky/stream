package com.kemsky.util
{
    /**
     * @private
     */
    public function compareXML(a:XML, b:XML, numeric:Boolean, caseInsensitive:Boolean):int
    {
        var result:int = 0;

        if (numeric)
        {
            result = compareNumber(parseFloat(String(a)), parseFloat(String(b)));
        }
        else
        {
            result = compareString(String(a), String(b), caseInsensitive);
        }

        return result;
    }
}
