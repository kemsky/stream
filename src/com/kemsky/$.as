package com.kemsky
{
    import com.kemsky.impl.Flex;
    import com.kemsky.impl.Stream;

    /**
     * Global function that creates Stream objects
     * @param rest objects used as source for Stream
     * @return created Stream object
     */
    public function $(...rest):Stream
    {
        if(rest.length == 0)
        {
            //empty $
            return new Stream();
        }
        else if(rest.length == 1)
        {
            if(Flex.available && [0] is Flex.collection)
            {
                //$ from collection
                return new Stream(rest[0].source);
            }
            else if(rest[0] is Array)
            {
                //$ from array
                return new Stream((rest[0] as Array).concat());
            }
            else if(Flex.available && rest[0] is Flex.list)
            {
                //$ from list
                return new Stream(rest[0].toArray());
            }
            else if(rest[0] == null || rest[0] === undefined)
            {
                //$ empty
                return new Stream();
            }
            else
            {
                //$ from one item
                return new Stream([rest[0]]);
            }
        }

        //$ from argument list
        return new Stream(rest.concat());
    }
}
