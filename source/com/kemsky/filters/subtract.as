/*
 *  Copyright: (c) 2016. Turtsevich Alexander
 *
 *  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.html
 *
 *  https://github.com/kemsky/stream
 */

package com.kemsky.filters
{
    public function subtract(...rest):Function
    {
        return function (item:*):*
        {
            var result:Number = rest[0] is Function ? rest[0](item): rest[0];

            for (var i:int = 1; i < rest.length; i++)
            {
                var f:* = rest[i];
                if(f is Function)
                {
                    result -= f(item);
                }
                else
                {
                    result -= f;
                }
            }
            return result;
        };
    }
}
