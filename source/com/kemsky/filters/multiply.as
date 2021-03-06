/*
 *  Copyright: (c) 2016. Turtsevich Alexander
 *
 *  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.html
 *
 *  https://github.com/kemsky/stream
 */

package com.kemsky.filters
{
    public function multiply(...rest):Function
    {
        return function (item:*):*
        {
            var result:Number = 1;
            for each (var f:* in rest)
            {
                if(f is Function)
                {
                    result *= f(item);
                }
                else
                {
                    result *= f;
                }
            }
            return result;
        };
    }
}
