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

    public function type(val1:*, clazz:Class):Function
    {
        return function (item:*):Boolean
        {
            return toValue(item, val1) is clazz;
        };
    }
}
