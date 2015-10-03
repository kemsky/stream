package com.kemsky.impl.filters
{
    /**
     * @private
     */
    public function toValue(item:*, value:*):*
    {
        var result:* = item;
        if (value is Function)
        {
            result = value(item);
        }
        else if(value !== undefined)
        {
            result = value;
        }
        return result;
    }
}
