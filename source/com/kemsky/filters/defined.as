/*
 *  Copyright: (c) 2016. Turtsevich Alexander
 *
 *  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.html
 */

package com.kemsky.filters
{
    import com.kemsky.support.toValue;

    public function defined(val:*):Function
    {
        return function (item:*):Boolean
        {
            return toValue(item, val) !== undefined;
        };
    }
}
