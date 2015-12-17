/*
 *  Copyright: (c) 2015. Turtsevich Alexander
 *
 *  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.html
 */

package com.kemsky.support
{
    /**
     * Stream error class
     */
    public class StreamError extends Error
    {
        /**
         * @inheritDoc
         */
        public function StreamError(message:String = null, errorID:int = 0)
        {
            super(message, errorID);
        }
    }
}
