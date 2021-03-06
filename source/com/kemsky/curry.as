/*
 *  Copyright: (c) 2016. Turtsevich Alexander
 *
 *  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.html
 *
 *  https://github.com/kemsky/stream
 */

package com.kemsky
{
    /**
     * Creates partially applied function
     * @param func source
     * @param args arguments to apply to func
     * @return partially applied function
     */
    public function curry(func:Function, ... args:Array):*
    {
        var arity:int = func.length;

        function currying(func:Function, arity:int, args:Array):*
        {
            return function curried(...left):*
            {
                if(left.length + args.length < arity)
                {
                    return currying(func, arity, args.concat(left));
                }
                return func.apply(this, args.concat(left));
            }
        }

        return currying(func, arity, args);
    }
}
