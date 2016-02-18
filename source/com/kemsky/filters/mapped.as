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

    public function mapped(val1:*, map:Object):Function
    {
        return function (item:*):Boolean
        {
            var v:* = toValue(item, val1);
            var value:Object = map[v];
            return !(value == null);
        };
    }
}
