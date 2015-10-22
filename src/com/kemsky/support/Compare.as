package com.kemsky.support
{
    import com.kemsky.Stream;

    /**
     * todo: register custom compare functions for custom types
     * @private
     */
    public class Compare
    {
        /**
         * Allows to use generic compare functions(le, ge, lt and others) for the following types:
         * Number, Date, XML, String or Boolean
         * @param a first item
         * @param b second item
         * @param options combination of Stream.CASEINSENSITIVE | Stream.DESCENDING | Stream.NUMERIC
         * @param equals compare is used to check equality
         * @return -1 if a &lt; b, 0 if a == b and 1 if a &gt; b
         */
        public static function compare(a:Object, b:Object, options:uint = 0, equals:Boolean = false):int
        {
            var result:int = 0;

            if (a == null && b == null)
            {
                result = 0;
            }
            else if (a == null)
            {
                result = -1;
            }
            else if (b == null)
            {
                result = 1;
            }
            else
            {
                var numeric:Boolean = (options & Stream.NUMERIC) == Stream.NUMERIC;

                var caseInsensitive:Boolean = (options & Stream.CASEINSENSITIVE) == Stream.CASEINSENSITIVE;

                var typeOfA:String = TypeCache.getQualifiedClassName(a);
                var typeOfB:String = TypeCache.getQualifiedClassName(b);

                if (typeOfA == typeOfB)
                {
                    switch (typeOfA)
                    {
                        case TypeCache.BOOLEAN:
                        {
                            result = compareNumber(Number(a), Number(b));
                            break;
                        }



                        case TypeCache.NUMBER:
                        {
                            result = compareNumber(a as Number, b as Number);
                            break;
                        }

                        case TypeCache.STRING:
                        {
                            result = compareString(a as String, b as String, caseInsensitive);
                            break;
                        }

                        case TypeCache.DATE:
                        {
                            result = compareDate(a as Date, b as Date);
                            break;
                        }

                        case TypeCache.XML_TYPE:
                        {
                            result = compareXML(a as XML, b as XML, numeric, caseInsensitive);
                            break;
                        }
                        default:
                        {
                            if (equals)
                            {
                                result = a == b ? 0 : -1;
                            }
                            else
                            {
                                throw new Error("Sort is not supported: " + typeOfA);
                            }
                        }
                    }
                }
                else // be consistent with the order we return here
                {
                    result = compareString(typeOfA, typeOfB, caseInsensitive);
                }
            }

            if ((options & Stream.DESCENDING) == Stream.DESCENDING)
            {
                result *= -1;
            }

            return result;
        }


        /**
         * @private
         */
        public static function compareXML(a:XML, b:XML, numeric:Boolean, caseInsensitive:Boolean):int
        {
            var result:int = 0;

            if (numeric)
            {
                result = compareNumber(parseFloat(a.toString()), parseFloat(b.toString()));
            }
            else
            {
                result = compareString(a.toString(), b.toString(), caseInsensitive);
            }

            return result;
        }

        /**
         * @private
         */
        public static function compareString(fa:String, fb:String, caseInsensitive:Boolean):int
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

        /**
         * @private
         */
        public static function compareNumber(fa:Number, fb:Number):int
        {
            if ((!(fa <= 0) && !(fa > 0)) && (!(fb <= 0) && !(fb > 0)))
            {
                return 0;
            }

            if (!(fa <= 0) && !(fa > 0))
            {
                return -1;
            }

            if (!(fb <= 0) && !(fb > 0))
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

        /**
         * @private
         */
        public static function compareDate(fa:Date, fb:Date):int
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
    }
}
