package com.kemsky
{
    import mx.collections.IList;

    /**
     * Global function that creates Stream objects
     * @param rest objects used as source for Stream
     * @return created Stream object
     * @example
     * <pre>
     *     var s:Stream = $(1, 2, 3);
     *     var s:Stream = $([1, 2, 3]);
     *     var s:Stream = $(new ArrayCollection([1, 2, 3]));
     *     var s:Stream = $(new ArrayList([1, 2, 3]));
     *     var s:Stream = $(new Stream([1, 2, 3]));
     *
     *     //All expressions are equivalent to:
     *     var s:Stream = new Stream([1, 2, 3])
     * </pre>
     */
    public function $(...rest):Stream
    {
        if (rest.length == 0)
        {
            //empty $
            return new Stream();
        }
        else if (rest.length == 1)
        {
            var arg:* = rest[0];

            if (arg is Array)
            {
                //$ from array
                return new Stream((arg as Array).concat());
            }
            else if (arg is Vector.<*> || arg is Vector.<Number> || arg is Vector.<int> || arg is Vector.<uint>)
            {
                var a:Array = [];
                for (var i:int = 0; i < arg.length; i++)
                {
                    a[i] = arg[i];
                }
                return new Stream(a);
            }
            else if (arg is IList)
            {
                //$ from list
                return new Stream(arg.toArray());
            }
            else
            {
                //$ from one item
                return new Stream([arg]);
            }
        }

        //$ from argument list
        return new Stream(rest.concat());
    }
}
