package com.kemsky.filters
{
    import com.kemsky.Stream;
    import com.kemsky.support.TypeCache;
    import com.kemsky.support.compareDate;
    import com.kemsky.support.compareNumber;
    import com.kemsky.support.compareString;
    import com.kemsky.support.compareXML;

    /**
     * Allows to use generic compare functions(le, ge, lt and others) for the following types:
     * Number, Date, XML, String or Boolean
     * @param a first item
     * @param b second item
     * @param options combination of Stream.CASEINSENSITIVE | Stream.DESCENDING | Stream.NUMERIC
     * @param equals compare is used to check equality
     * @return -1 if a &lt; b, 0 if a == b and 1 if a &gt; b
     */
    public function compare(a:Object, b:Object, options:uint = 0, equals:Boolean = false):int
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

                    case TypeCache.INT:
                    case TypeCache.UINT:
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
}

