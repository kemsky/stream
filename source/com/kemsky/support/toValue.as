/*
 *  Copyright: (c) 2016. Turtsevich Alexander
 *
 *  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.html
 */

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
