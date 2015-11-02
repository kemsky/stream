package com.kemsky
{
    /**
     * Creates combined function
     * @param rest a list of functions
     * @return combined function
     * @example
     * <pre>
     * var lower:Function = function(value:String):String
     * {
     *    return value.toLowerCase();
     * };
     *
     * var first:Function = function(value:String):String
     * {
     *    return value.charAt(0);
     * };
     *
     * var c:Function = combine(first, lower);
     * trace(c("ALEX"));
     * //a
     * </pre>
     */
    public function combine(...rest):Function
    {
        return function (arg:*):*
        {
            var result:* = arg;
            for each (var f:Function in rest)
            {
                result = f(result);
            }
            return result;
        };
    }
}
