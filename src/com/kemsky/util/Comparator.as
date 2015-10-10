package com.kemsky.util
{
    /**
     * @private
     */
    public class Comparator
    {
        public static function numericCompare(fa:Number, fb:Number):int
        {
            if (isNaNFast(fa) && isNaNFast(fb))
            {
                return 0;
            }

            if (isNaNFast(fa))
            {
                return -1;
            }

            if (isNaNFast(fb))
            {
                return 1;
            }

            if (fa < fb)
            {
                return -1;
            }

            if (fa > fb)
            {
                return 1;
            }

            return 0;
        }

        public static function dateCompare(fa:Date, fb:Date):int
        {
            var na:Number = fa.getTime();
            var nb:Number = fb.getTime();

            if (na < nb)
            {
                return -1;
            }

            if (na > nb)
            {
                return 1;
            }

            return 0;
        }

        public static function stringCompare(fa:String, fb:String, caseInsensitive:Boolean):int
        {
            // Convert to lowercase if we are case insensitive.
            if (caseInsensitive)
            {
                fa = fa.toLocaleLowerCase();
                fb = fb.toLocaleLowerCase();
            }

            var result:int = fa.localeCompare(fb);

            if (result < -1)
            {
                result = -1;
            }
            else if (result > 1)
            {
                result = 1;
            }

            return result;
        }

        public static function xmlCompare(a:XML, b:XML, numeric:Boolean, caseInsensitive:Boolean):int
        {
            var result:int = 0;

            if (numeric)
            {
                result = numericCompare(parseFloat(String(a)), parseFloat(String(b)));
            }
            else
            {
                result = stringCompare(String(a), String(b), caseInsensitive);
            }

            return result;
        }

        private static function isNaNFast(target:*):Boolean
        {
            return !(target <= 0) && !(target > 0);
        }
    }

}
