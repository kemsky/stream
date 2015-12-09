/*
 *  Copyright: (c) 2015. Turtsevich Alexander
 *
 *  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.html
 */

package com.kemsky.filters
{
    /**
     * Loopback (identity function) function, allows to use stream item as an argument for other functions
     * @param item current item
     * @return item passed as an argument
     */
    public function _(item:*):*
    {
        return item;
    }
}
