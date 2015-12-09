/*
 *  Copyright: (c) 2015. Turtsevich Alexander
 *
 *  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.html
 */

package com.kemsky.filters
{
    /**
     * todo Creates function that extracts named property from value
     * @param name name of the property or method (nested properties are supported: 'prop.prop1.prop2')
     * @param rest
     * @return function function that extracts named property or method from value
     */
    public function invoke(name:String, ...rest):Function
    {
        var path:Array = name.split(".");

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

        throw new Error("Property is too deep: '" + name + "', maximum nesting is 5");
    }
}
