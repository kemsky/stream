package com.kemsky
{
    import com.kemsky.support.Flex;

    /**
     * Global function that creates List objects
     * @param rest objects used as source for List
     * @return created List object
     * @example
     * <pre>
     *     var s:List = $(1, 2, 3);
     *     var s:List = $([1, 2, 3]);
     *     var s:List = $(new ArrayCollection([1, 2, 3]));
     *     var s:List = $(new ArrayList([1, 2, 3]));
     *     var s:List = $(new List([1, 2, 3]));
     *     var s:List = $([1], [2], [3]);//flattens arguments
     *
     *     //All expressions are equivalent to:
     *     var s:List = new List([1, 2, 3])
     * </pre>
     */
    public function $(...rest):List
    {
        if (rest.length == 0)
        {
            //empty $
            return new List();
        }
        else if (rest.length == 1)
        {
            var arg:* = rest[0];

            if (arg is Array)
            {
                //$ from array
                return new List((arg as Array).concat());
            }
            else if (arg is Vector.<*> || arg is Vector.<Number> || arg is Vector.<int> || arg is Vector.<uint>)
            {
                var a:Array = [];
                for (var i:int = 0; i < arg.length; i++)
                {
                    a[i] = arg[i];
                }
                return new List(a);
            }
            else if (Flex.available && arg is Flex.list)
            {
                //$ from list
                return new List(arg.toArray());
            }
            else
            {
                //$ from one item
                return new List([arg]);
            }
        }

        //$ from argument list
        return new List(rest.concat());
    }
}
