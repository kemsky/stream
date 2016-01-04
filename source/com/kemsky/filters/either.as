/*
 *  Copyright: (c) 2016. Turtsevich Alexander
 *
 *  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.html
 */

package com.kemsky.filters
{
    import com.kemsky.$;
    import com.kemsky.Stream;
    import com.kemsky.support.StreamError;
    import com.kemsky.support.toValue;

    /**
     * Creates function that checks if value equals to one of the arguments
     * @param value item or item property
     * @param rest arguments
     * @return function that checks if value equals to one of the arguments
     */
    public function either(value:*, ...rest):Function
    {
        var values:Stream = $.apply(null, rest);

        if (values.length == 0)
        {
            throw new StreamError("Function 'either' must have two or more arguments");
        }

        return function (item:*):Boolean
        {
            var val:* = toValue(item, value);

            var result:Boolean = values.some(function (val2:*):Boolean
            {
                return val == toValue(item, val2);
            });

            return result;
        };
    }
}
