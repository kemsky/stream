package com.kemsky.impl
{
    public function curry(func:Function, ... args:Array):*
    {
        var arity:int = func.length;

        function currying(func:Function, arity:int, args:Array):*
        {
            return function curried(... moreArgs:Array):*
            {
                if(moreArgs.length + args.length < arity)
                {
                    return currying(func, arity, args.concat(moreArgs));
                }
                return func.apply(this, args.concat(moreArgs));
            }
        };

        return currying(func, arity, args);
    }
}
