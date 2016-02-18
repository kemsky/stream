/*
 *  Copyright: (c) 2016. Turtsevich Alexander
 *
 *  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.html
 *
 *  https://github.com/kemsky/stream
 */

package com.kemsky.filters
{
    import com.kemsky.support.toValue;

    public function empty(val:*):Function
    {
        return function (item:*):Boolean
        {
            var value:* = toValue(item, val);
            return (value as String) == null || (value as String).length == 0;
        };
    }
}
