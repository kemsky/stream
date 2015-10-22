package com.kemsky.support
{
    /**
     * Converts value to actual value
     * @private
     */
    public function toValue(item:*, value:*):*
    {
        var result:* = item;
        if (value is Function)
        {
            result = value(item);
        }
        else
        {
            result = value;
        }
        return result;
    }
}
