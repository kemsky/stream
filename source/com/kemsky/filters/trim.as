/*
 *  Copyright: (c) 2016. Turtsevich Alexander
 *
 *  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.html
 */

package com.kemsky.filters
{
    import com.kemsky.support.toValue;

    import mx.utils.StringUtil;

    public function trim(val:*):Function
    {
        return function (item:*):String
        {
            var value:* = toValue(item, val);
            if(value is String)
            {
                return StringUtil.trim(value);
            }
            return "";
        };
    }
}
