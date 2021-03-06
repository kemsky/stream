package
{
    import mx.logging.ILogger;
    import mx.logging.Log;
    import mx.logging.targets.TraceTarget;

    public class Print
    {
        private static const log:ILogger = Log.getLogger("Print");

        private static const instance:Print = new Print();

        public function Print()
        {
            Log.addTarget(new TraceTarget());
        }

        public static function message(msg:String, ...args):void
        {
            log.info.apply(null, [msg].concat(args));
        }

        public static function items(...args):void
        {
            log.info.apply(null, [args.join(",")]);
        }
    }
}
