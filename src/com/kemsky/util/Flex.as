package com.kemsky.util
{
    import flash.utils.getDefinitionByName;

    /**
     * @private
     */
    public class Flex
    {
        private static const instance:Flex = new Flex();

        protected var list:Class;

        public var available:Boolean;

        public function Flex()
        {
            try
            {
                this.list = getDefinitionByName("mx.collections::IList") as Class;
                this.available = true;
            }
            catch (e:Error)
            {

            }
        }

        public static function get list():Class
        {
            return instance.list;
        }

        public static function get available():Boolean
        {
            return instance.available;
        }
    }
}
