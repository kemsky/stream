package com.kemsky.filters
{
    import com.kemsky.support.toValue;

    /**
     * Creates function that extracts named property from value
     * @param value item or function applied to item
     * @param name name of the property
     * @return function function that extracts named property from value
     */
    public function prop(value:*, name:String):Function
    {
        return function (item:*):*
        {
            item = toValue(item, value);
            return item.hasOwnProperty(name) ? item[name] : undefined;
        };
    }
}
