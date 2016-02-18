/*
 *  Copyright: (c) 2016. Turtsevich Alexander
 *
 *  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.html
 *
 *  https://github.com/kemsky/stream
 */

package com.kemsky.filters
{
    /**
     * Creates function that applies logical NOT to provided criteria
     * @param criteria arguments
     * @return function that applies logical NOT to provided criteria
     */
    public function not(criteria:Function):Function
    {
        return function (item:*):Boolean
        {
            return !criteria(item);
        };
    }
}
