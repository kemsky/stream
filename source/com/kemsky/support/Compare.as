/*
 *  Copyright: (c) 2016. Turtsevich Alexander
 *
 *  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.html
 */

package com.kemsky.support
{
    import com.kemsky.Stream;

    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;

    /**
     * todo: register custom compare functions for custom types
     * @private
     */
    public class Compare
    {
        private static const classToFullName:Dictionary = new Dictionary(true);

        public static const NUMBER:String = "Number";
        public static const STRING:String = "String";
        public static const BOOLEAN:String = "Boolean";
        public static const DATE:String = "Date";
        public static const XML_TYPE:String = "XML";
        public static const XML_LIST:String = "XMLList";
        public static const CLASS:String = "Class";
        public static const ARRAY:String = "Array";
        public static const UNDEFINED:String = "void";

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

                var typeOfA:String = getClassName(a);
                var typeOfB:String = getClassName(b);

                if (typeOfA == typeOfB)
                {
                    switch (typeOfA)
                    {
                        case BOOLEAN:
                            result = compareNumber(Number(a), Number(b));
                            break;
                        case NUMBER:
                            result = compareNumber(a as Number, b as Number);
                            break;
                        case STRING:
                            result = compareString(a as String, b as String, caseInsensitive);
                            break;
                        case DATE:
                            result = compareDate(a as Date, b as Date);
                            break;
                        case XML_TYPE:
                            result = compareXML(a as XML, b as XML, numeric, caseInsensitive);
                            break;
                        default:
                            if (equals)
                            {
                                result = a == b ? 0 : -1;
                            }
                            else
                            {
                                throw new StreamError("Compare is not supported: " + typeOfA);
                            }
                    }
                }
                else
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

        public static function getClassName(object:*):String
        {
            var cls:Class;
            if (object is XML)
            {
                return XML_TYPE;
            }
            else if (object is XMLList)
            {
                return XML_LIST;
            }
            else if (object is Class)
            {
                cls = object as Class;
            }
            else if (object === undefined)
            {
                return UNDEFINED;
            }
            else if (object != null)
            {
                cls = object.constructor;
            }

            var name:String = classToFullName[cls];
            if (name == null)
            {
                name = getQualifiedClassName(cls);
                classToFullName[cls] = name;
            }
            return name;
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
            if ((fa != fa) && (fb != fb))
            {
                return 0;
            }

            if (fa != fa)
            {
                return -1;
            }

            if (fb != fb)
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
