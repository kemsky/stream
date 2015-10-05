package com.kemsky.impl
{
    import flash.utils.getDefinitionByName;

    public class Flex
    {
        private static const instance:Flex = new Flex();

        protected var collection:Class;
        protected var list:Class;

        public var available:Boolean;

        public function Flex()
        {
            try
            {
                this.collection = getDefinitionByName("mx.collections::ArrayCollection") as Class;
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

        public static function get collection():Class
        {
            return instance.collection;
        }

        public static function get available():Boolean
        {
            return instance.available;
        }
    }
}
