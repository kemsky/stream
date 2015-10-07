package com.kemsky.impl.filters
{
    import com.kemsky.impl.Stream;

    /**
     * Allows to use generic compare functions for the following types:
     * Number, Date, XML, String or Boolean
     * @param a first item
     * @param b second item
     * @param options combination of Stream.CASEINSENSITIVE | Stream.DESCENDING | Stream.NUMERIC
     * @return -1, 0, 1
     */
    public function comparator(a:Object, b:Object, options:uint = 0, equals:Boolean = false):int
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

            if (numeric)
            {
                result = Comparator.numericCompare(Number(a), Number(b));
            }
            else
            {
                var caseInsensitive:Boolean = (options & Stream.CASEINSENSITIVE) == Stream.CASEINSENSITIVE;
                var descending:Boolean = (options & Stream.DESCENDING) == Stream.DESCENDING;

                var typeOfA:String = TypeCache.getQualifiedClassName(a);
                var typeOfB:String = TypeCache.getQualifiedClassName(b);

                if (typeOfA == typeOfB)
                {
                    switch (typeOfA)
                    {
                        case TypeCache.BOOLEAN:
                        {
                            result = Comparator.numericCompare(a, b);
                            break;
                        }

                        case TypeCache.NUMBER:
                        {
                            result = Comparator.numericCompare(a, b);
                            break;
                        }

                        case TypeCache.STRING:
                        {
                            result = Comparator.stringCompare(a, b, caseInsensitive);
                            break;
                        }

                        case TypeCache.DATE:
                        {
                            result = Comparator.dateCompare(a, b);
                            break;
                        }

                        case TypeCache.XML_TYPE:
                        {
                            result = Comparator.xmlCompare(a, b, numeric, caseInsensitive);
                            break;
                        }
                        default:
                        {
                            if(equals)
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
                    result = Comparator.stringCompare(typeOfA, typeOfB, caseInsensitive);
                }
            }
        }

        if(descending)
        {
            result *= -1;
        }

        return result;
    }
}

class Comparator
{
    /**
     * Pull the numbers from the objects and call the implementation.
     */
    public static function numericCompare(a:Object, b:Object):int
    {
        var fa:Number;
        try
        {
            fa = Number(a);
        }
        catch(error:Error)
        {
        }

        var fb:Number;
        try
        {
            fb = Number(b);
        }
        catch(error:Error)
        {
        }

        if (isNaNFast(fa) && isNaNFast(fb))
            return 0;

        if (isNaNFast(fa))
            return 1;

        if (isNaNFast(fb))
            return -1;

        if (fa < fb)
            return -1;

        if (fa > fb)
            return 1;

        return 0;
    }

    /**
     * Pull the date objects from the values and compare them.
     */
    public static function dateCompare(a:Object, b:Object):int
    {
        var fa:Date;
        try
        {
            fa = a as Date;
        }
        catch(error:Error)
        {
        }

        var fb:Date;
        try
        {
            fb = b as Date;
        }
        catch(error:Error)
        {
        }

        if (fa == null && fb == null)
            return 0;

        if (fa == null)
            return 1;

        if (fb == null)
            return -1;

        var na:Number = fa.getTime();
        var nb:Number = fb.getTime();

        if (na < nb)
            return -1;

        if (na > nb)
            return 1;

        return 0;
    }

    /**
     * Pull the strings from the objects and call the implementation.
     */
    public static function stringCompare(a:Object, b:Object, caseInsensitive:Boolean):int
    {
        var fa:String;
        try
        {
            fa = String(a);
        }
        catch(error:Error)
        {
        }

        var fb:String;
        try
        {
            fb = String(b);
        }
        catch(error:Error)
        {
        }

        if (fa == null && fb == null)
            return 0;

        if (fa == null)
            return 1;

        if (fb == null)
            return -1;

        // Convert to lowercase if we are case insensitive.
        if (caseInsensitive)
        {
            fa = fa.toLocaleLowerCase();
            fb = fb.toLocaleLowerCase();
        }

        var result:int = fa.localeCompare(fb);

        if (result < -1)
            result = -1;
        else if (result > 1)
            result = 1;

        return result;
    }

    /**
     * Pull the values out fo the XML object, then compare
     * using the string or numeric comparator depending
     * on the numeric flag.
     */
    public static function xmlCompare(a:Object, b:Object, numeric:Boolean, caseInsensitive:Boolean):int
    {
        var sa:String;
        try
        {
            sa = a.toString();
        }
        catch(error:Error)
        {
        }

        var sb:String;
        try
        {
            sb = b.toString();
        }
        catch(error:Error)
        {
        }

        if(numeric == true)
        {
            return numericCompare(parseFloat(sa), parseFloat(sb));
        }
        else
        {
            return stringCompare(sa, sb, caseInsensitive);
        }
    }

    private static function isNaNFast(target:*):Boolean
    {
        return !(target <= 0) && !(target > 0);
    }
}
