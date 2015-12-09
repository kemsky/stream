/*
 *  Copyright: (c) 2015. Turtsevich Alexander
 *
 *  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.html
 */

package com.kemsky.filters
{
    /**
     * Creates function that calculates logical OR value of provided arguments for an item
     * @param rest arguments
     * @return function that calculates logical OR value of provided arguments
     */
    public function or(...rest):Function
    {
        return function (item:*):Boolean
        {
            var result:Boolean;
            for each (var f:Function in rest)
            {
                result = f(item);
                if (result)
                {
                    break;
                }
            }
            return result;
        };
    }
}
