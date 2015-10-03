package com.kemsky
{
    import com.kemsky.impl.Stream;

    import mx.collections.ArrayCollection;

    public function $(...rest):Stream
    {
        if(rest.length == 0)
        {
            //empty $
            return new Stream();
        }
        else if(rest.length == 1)
        {
            if(rest[0] is ArrayCollection)
            {
                //$ from collection
                return new Stream(ArrayCollection(rest[0]).source);
            }
            else if(rest[0] is Array)
            {
                //$ from array
                return new Stream(rest[0]);
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
        return new Stream(rest);
    }
}
