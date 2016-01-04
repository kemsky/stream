/*
 *  Copyright: (c) 2016. Turtsevich Alexander
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
         * Constructor.
         * @param message error description.
         * @param errorID error number.
         */
        public function StreamError(message:String = null, errorID:int = 0)
        {
            super(message, errorID);
        }
    }
}
