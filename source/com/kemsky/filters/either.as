/*
 *  Copyright: (c) 2016. Turtsevich Alexander
 *
 *  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.html
 */

package com.kemsky.filters
{
    import com.kemsky.$;
    import com.kemsky.Stream;
    import com.kemsky.support.Compare;
    import com.kemsky.support.StreamError;
    import com.kemsky.support.toValue;

    /**
     * Creates function that checks if value equals to one of the arguments
     * @param value item or item property
     * @param enumeration arguments (any iterable type supported by stream)
     * @param options comparison options
     * @return function that checks if value equals to one of the arguments
     */
    public function either(value:*, enumeration:*, options:uint = 0):Function
    {
        var values:Stream = $(enumeration);

        if (values.length == 0)
        {
            throw new StreamError("Function 'either' must have non empty second argument");
        }

        return function (item:*):Boolean
        {
            var val:* = toValue(item, value);

            var result:Boolean = values.some(function (val2:*):Boolean
            {
                return Compare.compare(val, toValue(item, val2), options, true) == 0;
            });

            return result;
        };
    }
}
