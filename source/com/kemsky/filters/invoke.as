/*
 *  Copyright: (c) 2015. Turtsevich Alexander
 *
 *  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.html
 */

package com.kemsky.filters
{
    import com.kemsky.Stream;
    import com.kemsky.support.StreamError;

    /**
     * Creates function that calls named method on value.
     * @param name name of the method (nested properties are supported: 'prop.prop1.prop2.method' or any collection of strings).
     * @param rest method arguments.
     * @return function function that calls named method on value.
     */
    public function invoke(name:*, ...rest):Function
    {
        if(name == null || name === undefined)
        {
            throw new StreamError("Parameter 'name' must be not null");
        }

        var path:Array = null;

        if(name is String)
        {
            path = name.split(".");
        }
        else
        {
            var members:Stream = Stream.from(name);

            if(!members.every(type(_, String)))
            {
                throw new StreamError("Parameter 'name' must contain only String items");
            }

            path = members.array();
        }

        var p1:String = path.length > 0 ? path[0]: undefined;
        var p2:String = path.length > 1 ? path[1]: undefined;
        var p3:String = path.length > 2 ? path[2]: undefined;
        var p4:String = path.length > 3 ? path[3]: undefined;
        var p5:String = path.length > 4 ? path[4]: undefined;

        var args:Array = rest.concat();

        switch (path.length)
        {
            case 1:
                return function (item:*):*
                {
                    var result:* = undefined;
                    try
                    {
                        result = item[p1].apply(null, args);
                    }
                    catch(e:Error){}
                    return result;
                };
            case 2:
                return function (item:*):*
                {
                    var result:* = undefined;
                    try
                    {
                        result = item[p1][p2].apply(null, args);
                    }
                    catch(e:Error){}
                    return result;
                };
            case 3:
                return function (item:*):*
                {
                    var result:* = undefined;
                    try
                    {
                        result = item[p1][p2][p3].apply(null, args);
                    }
                    catch(e:Error){}
                    return result;
                };
            case 4:
                return function (item:*):*
                {
                    var result:* = undefined;
                    try
                    {
                        result = item[p1][p2][p3][p4].apply(null, args);
                    }
                    catch(e:Error){}
                    return result;
                };
            case 5:
                return function (item:*):*
                {
                    var result:* = undefined;
                    try
                    {
                        result = item[p1][p2][p3][p4][p5].apply(null, args);
                    }
                    catch(e:Error){}
                    return result;
                };
        }

        throw new StreamError("Property is too deep: '" + name + "', maximum nesting is 5");
    }
}
