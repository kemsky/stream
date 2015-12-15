/*
 *  Copyright: (c) 2015. Turtsevich Alexander
 *
 *  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.html
 */

package com.kemsky.support
{
    public class StreamError extends Error
    {
        public function StreamError(message:String = null, errorID:int = 0)
        {
            super(message, errorID);
        }
    }
}
